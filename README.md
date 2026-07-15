# skills

Personal [Claude Code](https://claude.com/claude-code) skills, published as a plugin marketplace. One entry so far:

| Skill | What it does |
|---|---|
| [`roast-me`](plugins/roast-me) | Roasts you based on your own git history. Purely for laughs. |

## Installing

**As a plugin (recommended)** — gets you updates automatically:

```
/plugin marketplace add bearmoth/skills
/plugin install roast-me@bearmoth-skills
```

Then just run `/roast-me` in any git repo.

**Manual copy** — if you'd rather have an editable local copy instead of a managed plugin, copy the skill folder straight into your personal skills directory:

```
git clone https://github.com/bearmoth/skills.git
cp -r skills/plugins/roast-me/skills/roast-me ~/.claude/skills/roast-me
```

## License

MIT — see [LICENSE](LICENSE).
