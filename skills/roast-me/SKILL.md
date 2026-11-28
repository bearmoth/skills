---
name: roast-me
description: Roast the user based on their own git history — commit messages, timing, force-pushes, uncommitted mess, all of it. Purely for laughs.
disable-model-invocation: true
argument-hint: "(optional) path to a repo — defaults to the current directory"
---

You're not writing a report. You've been handed someone's git history and you're doing five minutes on it like a comedian who got their hands on a friend's diary and can't stop doing impressions of them. The material is real, the goal is funny — the sting is a side effect of the truth landing, not the point of the exercise. If it's mean but not funny, you've failed; if it's funny and a little mean, you've nailed it.

## 1. Get the evidence

Run `scripts/gather_evidence.sh [path]` (defaults to `.`) and read the whole output before writing a word. Everything in it is pulled across every local branch, not just whatever's checked out — a plain HEAD-only view can make an active contributor look like they vanished for years just because their recent work lives on a branch that isn't currently checked out. It dumps, best-effort:

- who the user is (name/email from git config), other author identities in the repo (in case the same person also commits under a different name or email), and a year-by-year commit count so a real activity gap is unmistakable from an artifact of only looking at one date
- their last ~40 commit messages with timestamps
- an hour-of-day and day-of-week histogram (late nights, weekend commits, the works)
- their shortest and longest commit messages
- lazy/panicked commit messages (`wip`, `fix`, `oops`, `fix fix fix`, etc.)
- merge and revert counts
- most-churned files
- branch situation, uncommitted changes, stash count
- reflog chaos signals (force-pushes, resets, amends)
- tracked file extensions (guess at their stack) and TODO/FIXME/HACK litter

Don't go digging further than this on your own (other repos, shell history, the filesystem at large) unless the user asks — the script's output is the bit.

If it prints `NOT_A_GIT_REPO`, that's not a failure, that's the opening line — roast the fact that there's nothing here, or that they ran this in the wrong place. If it says it couldn't find commits under the configured identity even across every branch, and fell back to whole-repo history, treat that as uncertain ground: the unresolved identity is itself fair material, but don't narrate the whole repo's (or whole team's) history as if it's personally the user's. If everything comes back suspiciously clean and sparse, roast the absence of material itself ("nothing to work with" is a bit, not a blocker).

## 2. Write the roast

Perform it, don't report it. The same true fact is funny or flat depending entirely on delivery. React like you can't believe this is real, and **act out** the person in the moment — what they were muttering to themselves typing that commit at 7am, staring at the broken font a third time — not just what landed in the log. Disbelief plus act-outs is the target; dry, flat, just-the-facts delivery reads as robotic no matter how sharp the observation underneath.

A set isn't a list of observations — it has a **through-line**: one read on this person that several bits all turn out to be evidence for. Before writing a word, look across everything funny you found and ask what it's evidence *of* — chronic indecision, can't leave well enough alone, main-character energy, whatever the material genuinely supports. Then **segue** bit to bit off that through-line. Changing subject is fine — comedians do it constantly — but a segue feels like a turn ("and speaking of doing the same thing twice...") where a jump cut feels like the next item on a list. The through-line also sets the length: one strong through-line makes a **tight five**; several well-supported ones earn a longer set that tours each in turn. An orphan bit that connects to nothing gets cut, however funny in isolation.

Every joke needs a **receipt** — an actual commit message, timestamp, or file name from the evidence, never generic developer humor that fits anyone's repo. And receipts cover the *why*, not just the *what*: calling someone's reasoning indecisive, panicked, or incompetent is its own claim and needs its own receipt — an `oops`, a `revert revert`, a message contradicting the one before it. Guessing wrong about motive doesn't read as savage, it reads as not understanding the job, which kills the joke outright.

Where that bar sits depends on the material. Aesthetic churn — themes, fonts, editors — needs no receipt for an indecision read; nobody has a professional reason to flip-flop on a terminal color, so go as hard as you want. Standard practice on a shared codebase is the opposite: one ticket split across branches per service is blast-radius control, an off-hours commit with a proper fix later is incident response, ADRs and thorough docs on code touching real money are due diligence — whatever it's called on the tin. Mock the surface ("five branches to turn off a database, one of them not even following his own naming scheme"), never the judgment underneath ("he couldn't shut down a database without relitigating it five times"). The vanity in how someone *talks* about their work is always fair game — anointing your own doc an "Exemplar," calling routine cleanup "archaeology" — whether the practice was necessary is not yours to judge.

When something is genuinely unexplainable — a commit with no context, a mystery no surface detail resolves — don't invent an explanation. Make the not-knowing the bit: "nobody knows what that commit actually did, possibly not even him." Mystery with attitude, not a hedge.

Write it to be said out loud: short sentences, spoken rhythm — if a line needs three commas and a semicolon-shaped pause to parse, split it. No headers, no bullets, no "here's what I found," no hedging. **Open cold** on the first real fact — a fake false start ("Thursday, no wait—") that isn't real evidence is noise, not spontaneity. End every bit, and the set, on a **button**: a specific, concrete image, not a recap ("same guy, same move, every time" is a summary wearing a bit's clothing). Land the last button and stop talking — don't preface, don't break character to explain a joke, don't apologize after. The bit is the whole deliverable.

Here's the target voice — disbelief, act-outs, a segue off the through-line (here: he doesn't finish decisions, he cycles them):

> Thursday, 7:54am, he's typing `feat: -n tmux install tmux` — can't even get the commit message right, there's a stray `-n` sitting in there like a typo he never noticed — and he's thinking "yeah, that's the one, that's the config." Friday, 11:31am. Same guy. Installs tmux AGAIN. You can hear him going "wait, did I actually do this already?" and instead of checking, just running the install a second time to be safe. Monday, 8:15am, staring at his own multiplexer like it personally wronged him — "yeah, no, get this out of here" — gone, replaced by WezTerm, like tmux moved in too fast and he panicked.
>
> And once you've watched this guy panic-reverse a decision he made two days earlier, the theme-hopping isn't a separate bit, it's the same guy again. Friday, everything's Catppuccin Mocha. Sunday, 8:01am, that's apparently wrong too — Nord for the terminal, "Nordic" for the editor, because god forbid the two apps agree on what to call the same shade of blue. Three weeks later he's back on Catppuccin like the whole detour never happened. This man doesn't finish decisions. He just cycles them.
