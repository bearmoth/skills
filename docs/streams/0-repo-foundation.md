# S0: Repo foundation

**Branch:** `stream-0-repo-foundation` · **Kind:** autonomous `/goal` ·
**Starts:** now · **Blocks:** S1b, S2b

## Intent

Restructure this repo so its skills install in every runtime, with Claude Code
reading them through symlinks (F2). Today the repo is only a Claude Code plugin
marketplace (`.claude-plugin/marketplace.json`, `plugins/roast-me/…`), and its
README's manual install is a `cp -r` into `~/.claude/skills/`.

## Inputs

- Decision log F1–F6, plus P2 and P5.
- One working example of the proposed layout (F3) already exists on the
  maintainer's machine for skills from another source: `~/.agents/skills/<name>`
  is a symlink into a clone, and `~/.claude/skills/<name>` is a symlink to
  `~/.agents/skills/<name>`. Copy the *layout*, not anybody's scripts.

## Five questions

- **Done:** skills live at `skills/<name>/` (F5). An install script creates the
  F3 symlinks for every skill in `skills/`. The README documents installing for
  multiple runtimes. F6 is resolved, or written up for the maintainer in the PR.
- **Check:** the goal's commands, with their output in the transcript.
- **Scope:** only S0's files (see the [README](README.md) table). Tests use a
  temporary `HOME`, never the real one.
- **Stop:** the goal's turn limit, the same check failing 3 times, any decision
  missing from the log, or anything that would delete a folder that isn't a
  symlink.
- **Sign-off:** the maintainer reviews and merges the PR. Installing for real
  on the maintainer's machine happens after merge, and is the maintainer's job.
  Note that `~/.claude/skills/roast-me` is currently a hand-made copy, which F4
  must leave alone.

## Goal

```
/goal All of the following hold, each shown by command output in this transcript:
(1) roast-me lives at skills/roast-me/ and its scripts still run from there;
(2) with HOME set to a new empty temp dir, the install script exits 0 and
    `ls -la $HOME/.agents/skills $HOME/.claude/skills` shows
    .agents/skills/roast-me -> <repo>/skills/roast-me and
    .claude/skills/roast-me -> $HOME/.agents/skills/roast-me;
(3) running the install script a second time exits 0 and changes nothing (same ls output);
(4) with a fresh temp HOME holding a real (non-symlink) folder .claude/skills/roast-me,
    the script leaves that folder untouched and reports it;
(5) the README's install section describes the new layout for more than one runtime,
    and F6 is either resolved or written up as a question in the PR description;
(6) the work is committed on stream-0-repo-foundation and a PR against main is open, not merged.
Or stop after 40 turns.
```
