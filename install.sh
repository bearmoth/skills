#!/bin/sh
# Link every skill in this repo's skills/ folder into the user's skill folders:
#
#   ~/.agents/skills/<name>  ->  <this repo>/skills/<name>
#   ~/.claude/skills/<name>  ->  ~/.agents/skills/<name>
#
# Safe to re-run: links that are already correct are left as they are.
# Never overwrites or deletes anything that is already at a link's path,
# whether a real folder, a file, or a symlink pointing somewhere else. It
# reports it and leaves it alone. Exits 1 if anything was skipped, so the
# install is known to be incomplete; 0 otherwise.
#
# POSIX sh, no dependencies.

set -eu

REPO="$(cd "$(dirname "$0")" && pwd -P)"
AGENTS_DIR="$HOME/.agents/skills"
CLAUDE_DIR="$HOME/.claude/skills"

skipped=0

# link <path> <target>: make <path> a symlink to <target>, unless something is
# already there. Returns 0 if the link exists and is correct afterwards.
link() {
  path=$1
  target=$2
  if [ -L "$path" ]; then
    current="$(readlink "$path")"
    if [ "$current" = "$target" ]; then
      echo "ok       $path -> $target"
      return 0
    fi
    echo "SKIPPED  $path is a symlink to $current, not $target. Left alone." >&2
    return 1
  fi
  if [ -e "$path" ]; then
    echo "SKIPPED  $path already exists and is not a symlink. Left alone." >&2
    return 1
  fi
  ln -s "$target" "$path"
  echo "linked   $path -> $target"
}

found=0
for dir in "$REPO"/skills/*/; do
  [ -f "$dir/SKILL.md" ] || continue
  found=1
  name="$(basename "$dir")"
  mkdir -p "$AGENTS_DIR" "$CLAUDE_DIR"

  if link "$AGENTS_DIR/$name" "$REPO/skills/$name"; then
    link "$CLAUDE_DIR/$name" "$AGENTS_DIR/$name" || skipped=$((skipped + 1))
  else
    # The shared link isn't ours, so a Claude link to it would point at
    # something this repo doesn't own.
    echo "SKIPPED  $CLAUDE_DIR/$name not linked, because $AGENTS_DIR/$name isn't this repo's." >&2
    skipped=$((skipped + 1))
  fi
done

if [ "$found" -eq 0 ]; then
  echo "No skills found in $REPO/skills" >&2
  exit 1
fi

if [ "$skipped" -gt 0 ]; then
  echo "$skipped skill(s) not fully installed. Move the existing item out of the way and re-run to install them." >&2
  exit 1
fi
