#!/usr/bin/env bash
# Dumps raw material for the roast-me skill to riff on. Best-effort: every
# section degrades gracefully to "none found" rather than aborting, because
# a thin repo is itself a joke, not an error.
#
# Everything reads with --all (every local branch, not just HEAD). A plain
# `git log` only walks commits reachable from the currently checked-out
# branch — on a repo with a lot of unmerged branch activity, that can make an
# active contributor look like they vanished for years when their commits
# are simply sitting on branches other than the one checked out right now.

TARGET="${1:-.}"
cd "$TARGET" 2>/dev/null || { echo "NOT_A_DIRECTORY"; exit 0; }

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "NOT_A_GIT_REPO"
  echo "path: $(pwd)"
  echo "files_here: $(ls -1 | wc -l | tr -d ' ')"
  exit 0
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
EMAIL="$(git config user.email)"
NAME="$(git config user.name)"

echo "=== IDENTITY ==="
echo "name: ${NAME:-unknown}"
echo "email: ${EMAIL:-unknown}"
echo "repo_root: $REPO_ROOT"
echo "remote: $(git remote get-url origin 2>/dev/null || echo none)"

TOTAL_COMMITS="$(git log --all --oneline 2>/dev/null | wc -l | tr -d ' ')"
USER_COMMITS=0
if [ -n "$EMAIL" ]; then
  USER_COMMITS="$(git log --all --author="$EMAIL" --oneline 2>/dev/null | wc -l | tr -d ' ')"
fi
echo "total_commits_in_repo (all local branches): $TOTAL_COMMITS"
echo "commits_by_user (all local branches): $USER_COMMITS"

# If the user has no commits under their configured email even across every
# branch, fall back to repo-wide data so there's still something to roast
# (and that fact itself is roast material) — but note it explicitly, because
# the writer should NOT narrate whole-repo/whole-team history as if it were
# personally the user's.
AUTHOR_FILTER=(--all --author="$EMAIL")
IDENTITY_CONFIDENT=true
if [ "$USER_COMMITS" = "0" ]; then
  echo "note: no commits found for configured email on any local branch; falling back to whole-repo history — do NOT narrate this as the user's personal timeline"
  AUTHOR_FILTER=(--all)
  IDENTITY_CONFIDENT=false
fi

echo ""
echo "=== OTHER AUTHOR IDENTITIES IN THIS REPO (top 15 by commit count, all branches) ==="
echo "Same human sometimes commits under more than one name/email (different"
echo "machines, old accounts, etc). If one of these looks like it could be the"
echo "same person as the identity above, treat facts credited to it with the"
echo "same caution as facts you're not sure about — don't silently merge them,"
echo "but don't confidently claim 'that's someone else' either."
git shortlog -sne --all 2>/dev/null | head -15

if [ -n "$EMAIL" ]; then
  echo ""
  echo "=== YOUR COMMIT TIMELINE (all local branches, by year) ==="
  echo "Ground truth for whether there's a real gap in activity. A single"
  echo "stale-looking 'most recent commit' date can be an artifact of only"
  echo "looking at one branch — trust this full timeline over any one date."
  git log --all --author="$EMAIL" --pretty=format:'%ad' --date=format:'%Y' 2>/dev/null | sort | uniq -c
fi

echo ""
echo "=== REPO AGE ==="
FIRST_DATE="$(git log --all --reverse --pretty=format:'%ad' --date=short 2>/dev/null | head -1)"
LAST_DATE="$(git log --all -1 --pretty=format:'%ad' --date=short 2>/dev/null)"
echo "repo_first_commit (any author): ${FIRST_DATE:-unknown}"
echo "repo_last_commit (any author): ${LAST_DATE:-unknown}"
if [ "$IDENTITY_CONFIDENT" = true ]; then
  USER_FIRST="$(git log "${AUTHOR_FILTER[@]}" --reverse --pretty=format:'%ad' --date=short 2>/dev/null | head -1)"
  USER_LAST="$(git log "${AUTHOR_FILTER[@]}" -1 --pretty=format:'%ad' --date=short 2>/dev/null)"
  echo "user_first_commit: ${USER_FIRST:-unknown}"
  echo "user_last_commit: ${USER_LAST:-unknown}"
fi

echo ""
echo "=== RECENT COMMIT MESSAGES (up to 40, newest first) ==="
git log "${AUTHOR_FILTER[@]}" -40 --pretty=format:'%ad | %s' --date=format:'%Y-%m-%d %H:%M %a' 2>/dev/null

echo ""
echo ""
echo "=== COMMIT HOUR HISTOGRAM (24h, count per hour) ==="
git log "${AUTHOR_FILTER[@]}" --pretty=format:'%ad' --date=format:'%H' 2>/dev/null | sort | uniq -c | sort -rn

echo ""
echo "=== COMMIT DAY-OF-WEEK HISTOGRAM ==="
git log "${AUTHOR_FILTER[@]}" --pretty=format:'%ad' --date=format:'%a' 2>/dev/null | sort | uniq -c | sort -rn

echo ""
echo "=== MESSAGE LENGTH EXTREMES ==="
echo "-- shortest messages --"
git log "${AUTHOR_FILTER[@]}" --pretty=format:'%s' 2>/dev/null | awk '{ print length, $0 }' | sort -n | head -5
echo "-- longest messages --"
git log "${AUTHOR_FILTER[@]}" --pretty=format:'%s' 2>/dev/null | awk '{ print length, $0 }' | sort -rn | head -5

echo ""
echo "=== SUSPICIOUS COMMIT MESSAGE PATTERNS ==="
git log "${AUTHOR_FILTER[@]}" --pretty=format:'%s' 2>/dev/null | grep -Eic '^(wip|fix|fixed|fix fix|oops|temp|asdf|test|misc|stuff|final|final2|actually fix|forgot|typo|revert revert|\.|update|changes|idk|please work|why|ugh)$|fix.*fix|^\.$' | xargs -I{} echo "count_of_lazy_messages: {}"
echo "-- examples --"
git log "${AUTHOR_FILTER[@]}" --pretty=format:'%s' 2>/dev/null | grep -Ei '^(wip|fix|fixed|oops|temp|asdf|test|misc|stuff|final|final2|forgot|typo|idk|please work|why|ugh)$|fix.*fix|^\.$' | sort | uniq -c | sort -rn | head -10

echo ""
echo "=== MERGES / REVERTS ==="
echo "merge_commits: $(git log "${AUTHOR_FILTER[@]}" --merges --oneline 2>/dev/null | wc -l | tr -d ' ')"
echo "revert_commits: $(git log "${AUTHOR_FILTER[@]}" --oneline 2>/dev/null | grep -ic 'revert' | tr -d ' ')"

echo ""
echo "=== MOST CHURNED FILES (by this user) ==="
git log "${AUTHOR_FILTER[@]}" --name-only --pretty=format: 2>/dev/null | grep -v '^$' | sort | uniq -c | sort -rn | head -10

echo ""
echo "=== BRANCHES ==="
echo "current_branch: $(git branch --show-current 2>/dev/null)"
echo "local_branch_count: $(git branch --list 2>/dev/null | wc -l | tr -d ' ')"
git branch --list --format='%(refname:short) | last commit %(committerdate:relative)' 2>/dev/null | head -15

echo ""
echo "=== WORKING TREE STATE ==="
echo "uncommitted_changes: $(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
echo "untracked_files: $(git status --porcelain 2>/dev/null | grep -c '^??')"
echo "stash_count: $(git stash list 2>/dev/null | wc -l | tr -d ' ')"

echo ""
echo "=== REFLOG SIGNS OF CHAOS (force pushes, resets, amends) ==="
git reflog show --all 2>/dev/null | grep -Eic 'forced-update|rebase|reset|commit \(amend\)' | xargs -I{} echo "chaos_events_in_reflog: {}"

echo ""
echo "=== LANGUAGE / STACK GUESS (tracked file extensions) ==="
git ls-files 2>/dev/null | grep -o '\.[a-zA-Z0-9]*$' | sort | uniq -c | sort -rn | head -10

echo ""
echo "=== TODO / FIXME LITTER (tracked files, current snapshot) ==="
git grep -Ic 'TODO|FIXME|HACK' -- . 2>/dev/null | awk -F: '{sum+=$2} END {print "todo_fixme_hack_count:", sum+0}'
