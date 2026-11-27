# skills

Personal agent skills, written to the [Agent Skills](https://agentskills.io) format so they work in more than one runtime. One entry so far:

| Skill | What it does |
|---|---|
| [`roast-me`](skills/roast-me) | Roasts you based on your own git history. Purely for laughs. |

Each skill lives in its own folder at `skills/<name>/`, with a `SKILL.md` and any files it bundles.

## Installing

### Any runtime: clone and link

Clone the repo somewhere it will stay, then run the install script:

```
git clone https://github.com/bearmoth/skills.git ~/Dev/skills
~/Dev/skills/install.sh
```

For every skill in `skills/`, the script creates two symlinks:

```
~/.agents/skills/<name>  ->  <clone>/skills/<name>
~/.claude/skills/<name>  ->  ~/.agents/skills/<name>
```

- `~/.agents/skills/` is the shared, runtime-neutral folder. Runtimes that read user skills from there pick the skills up with no extra step. OpenAI's Codex documentation lists `$HOME/.agents/skills` as its user-level skills folder. Check your runtime's docs to confirm.
- `~/.claude/skills/` is where Claude Code reads personal skills. The link goes through `~/.agents/skills/`, so both runtimes always see the same files.
- **Other runtimes** that read skills from a different folder: add a symlink from that folder to `~/.agents/skills/<name>`, the same way the Claude Code link does.

Because they are links, `git pull` in the clone updates every runtime at once. Run the script again after pulling to link any new skills. It is safe to re-run: links that are already correct stay as they are.

Run it from a clone you keep, not from a git worktree or a temporary checkout. The links point at the clone's path, so deleting that checkout leaves them broken.

**The script never overwrites anything.** If something already exists at a link's path, it reports it, leaves it alone and exits with status 1. That covers a real folder (for example an older hand-copied version of a skill), a file, or a symlink pointing somewhere else. To install that skill, move the existing item out of the way yourself and run the script again.

### Claude Code: as a plugin

The repo is also a Claude Code plugin marketplace. A plugin install updates itself, but only works in Claude Code:

```
/plugin marketplace add bearmoth/skills
/plugin install roast-me@bearmoth-skills
```

The plugin reads the same `skills/roast-me/` folder, so there is one copy of each skill. Use either the plugin or the symlinks for a given skill, not both, or you'll have two installed copies of the same skill.

Then run `/roast-me` in any git repo.

## License

MIT — see [LICENSE](LICENSE).
