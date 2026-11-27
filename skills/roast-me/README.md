# roast-me

A satirical [Claude Code](https://claude.com/claude-code) skill that roasts you based on your own git history — commit messages, timing, force-pushes, uncommitted mess, all of it. Purely for laughs, delivered as a stand-up bit, not a report.

Run it with `/roast-me` (or `/roast-me <path>` to point it at a different repo — it defaults to the current directory). It only runs when you explicitly invoke it; it never triggers itself.

## Sample output

> Thursday, 7:54am, he's typing `feat: -n tmux install tmux` — can't even get the commit message right, there's a stray `-n` sitting in there like a typo he never noticed — and he's thinking "yeah, that's the one, that's the config." Friday, 11:31am. Same guy. Installs tmux AGAIN. You can hear him going "wait, did I actually do this already?" and instead of checking, just running the install a second time to be safe. Monday, 8:15am, staring at his own multiplexer like it personally wronged him — "yeah, no, get this out of here" — gone, replaced by WezTerm, like tmux moved in too fast and he panicked.

## How it works

A bundled script (`scripts/gather_evidence.sh`) pulls raw material from git — commit messages, timing histograms, reflog chaos, branch and stash state — across every local branch, not just whatever's checked out. Claude reads that evidence and performs a roast from it: no headers, no bullet points, just a comedian doing five minutes on your diary. See [`SKILL.md`](SKILL.md) for the full writing guidance, including the rules it follows to keep the humor sharp without guessing at things it can't actually verify (like mistaking a legitimate engineering decision for incompetence).

## Scope

By default it only looks at the current repo — nothing system-wide, nothing across other projects, no shell history. That's a deliberate choice to keep it simple and fast; there's plenty of material in one repo's history.
