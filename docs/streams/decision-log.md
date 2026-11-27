# Decision log

Decisions from the design conversation of 2026-11-27 that set up these streams.
This is the **input** to the streams, not a set of requirements. Streams 1a and 2a
turn it into requirements.

**Status**
- **decided**: the maintainer explicitly accepted it.
- **proposed**: inferred or suggested by the agent, and not explicitly accepted.
  Treat it as a recommendation and put it to the maintainer before relying on it.
- **open**: not yet decided.

A stream that needs a decision not listed here **stops and asks**. It doesn't guess.

## Principles (all streams)

| ID | Decision | Status |
|---|---|---|
| P1 | "I don't know" and "I couldn't do it" are correct, successful outcomes. A confident wrong answer is the worst outcome. False confidence must never be encouraged. | decided |
| P2 | Don't trust existing skills by default. Skills owned by a team (outside this repo) are not used at all. The maintainer's own dotfiles skills may be suggested only if they are good quality, and only once their origin has been verified. | decided |
| P3 | Conventions that must work in every runtime are plain text (skill bodies, reference files). Runtime-specific features (output styles, hooks, plugins) are optional extras on top, never the only way a convention is delivered. | decided |
| P4 | Skills refer to each other's conventions **by skill name**, never by file path. | decided |
| P5 | Per-repo knowledge never goes into the project being worked on: no PR diffs, and it must survive worktree removal. | decided |

## Requirements format and process (stream 1)

| ID | Decision | Status |
|---|---|---|
| R1 | Write requirements before a design doc. Requirements become the evals and the reference reviewers check against. | decided |
| R2 | Format: an EARS sentence as the requirement, with OpenSpec-style GIVEN/WHEN/THEN scenarios under it (see ADR-0001). | decided |
| R3 | Wrap OpenSpec's format; don't adopt or bend its tool (ADR-0001). | decided |
| R4 | The four rules for combining the formats (ADR-0001, Consequences). | proposed |
| R5 | Each requirement has a status (decided or proposed) and a source. | decided |
| R6 | Status and source are written as `**Status**: … · **Source**: …` metadata lines. | proposed |
| R7 | Creation process: draft from the conversation, mark decided or proposed, a fresh reviewer checks the draft without the author's reasoning, then the maintainer approves in rounds. Nothing becomes decided without the maintainer. | decided |
| R8 | A deterministic lint checks four things: an EARS pattern with clauses in order; exactly one SHALL; a status line reading decided or proposed; at least one scenario. `openspec validate` is an optional extra. | decided |
| R9 | The requirements method is a reusable skill in this repo, built as its own stream. | decided |
| R10 | Requirement files live at `openspec/specs/<skill-name>/spec.md`, so `openspec validate` works without changes. Stream 1a confirms that path by **reading** OpenSpec's source, not by installing it. | proposed |
| R11 | Changes to existing requirements are written as ADDED / MODIFIED / REMOVED deltas. | proposed |
| R12 | Name of the skill: `requirements`. | proposed |
| R13 | The lint has no dependencies (POSIX sh or the Python standard library), so it runs anywhere. | proposed |

## Repo foundation (stream 0)

| ID | Decision | Status |
|---|---|---|
| F1 | The skills live in this repo. | decided |
| F2 | Installation works across runtimes, with a symlink for Claude Code. | decided |
| F3 | Install layout: `~/.agents/skills/<name>` is a symlink into the clone, and `~/.claude/skills/<name>` is a symlink to `~/.agents/skills/<name>`. | proposed |
| F4 | The installer never overwrites or deletes an existing folder that isn't a symlink. It reports it and leaves it alone. | proposed |
| F5 | Canonical skill location in the repo: `skills/<name>/`. | proposed |
| F6 | The existing plugin marketplace keeps working only if that's possible without duplicating skill files. Otherwise this is put to the maintainer at the PR. | open |

## Verification and architecture skills (stream 2)

### Shape

| ID | Decision | Status |
|---|---|---|
| A1 | Two workflow skills: `system-map` (standalone, maps an existing system top-down) and `architecture-design` (the design conversation). | decided |
| A2 | Top-down along C4 levels: high-level details first, going deeper only where appropriate or when asked. | decided |
| A3 | A new design is the same conversation, starting from an empty map. | proposed |
| A4 | Before any design question, `system-map` shows the current-state map, with each element tagged verified, inferred or unknown, and the maintainer confirms it. | proposed |
| A5 | A living design doc with a Mermaid C4 diagram per level, updated as decisions are settled. Each question is labeled with its level and branch. | proposed |
| A6 | Design options name the design pattern they use, with its trade-offs and a recommendation. | proposed |
| A7 | Build order: `verify`, then `system-map`, then `architecture-design`. | decided |

### `verify`

| ID | Decision | Status |
|---|---|---|
| V1 | `verify` is a primitive the maintainer can trigger and that the model can also trigger. It splits text into individual claims and has a fresh agent try to refute each one. | decided |
| V2 | Certainty levels are defined in `verify`'s `CERTAINTY.md`. | decided |
| V3 | Level names: verified (ran it), verified (read it), inferred (from X), can't be checked here, refuted, plus "not checked: <reason>". | proposed |
| V4 | The convention for briefing a fresh agent without biasing it (give it the artefact and the reference, never the author's conclusion) is shared reference text. | decided |
| V5 | The checker's brief restates the certainty levels and the per-repo facts explicitly, because some agent types load no instruction files at all (see Facts). | proposed |
| V6 | Per-repo knowledge lives at `${XDG_STATE_HOME:-~/.local/state}/verify/<repo-key>.md`, which can be overridden with an environment variable. The key is the normalized `origin` URL, falling back to the hash of the first commit. | decided |
| V7 | Each per-repo entry is a claim with a certainty level, date and commit. Old entries are re-checked before they're relied on. | decided |
| V8 | The per-repo file is a map of **where the truth is** for each kind of claim (structure, behavior, runtime/config, history/intent, external, can't be checked here), not a list of commands. The general method lives in `verify` (`METHODS.md`). | proposed |
| V9 | Known blind spots for a repo build up in its per-repo file, and future searches start from them. | decided |
| V10 | Claims about everything ("only", "never", "all") need a positive control (the search must find a known instance), at least two independent methods, and the scope reported as part of the result. Such a claim gets at most "verified within scope X". | proposed |
| V11 | Caching: behavior checks run through the repo's task runner use its cache. Everything else is keyed by the whole commit plus the lockfile. Runtime and config claims are never cached, or kept only for a short time limit. | decided |
| V12 | Useful probe scripts are saved in the state folder and re-run their positive control before their result is used. Turning one into a real test in the repo is the maintainer's decision. | proposed |
| V13 | Unknown is the default. Every inference is labeled. A check that can't run is never replaced by a weaker one. Partial work is stated as partial. Unknown and refuted claims are listed first. A report where everything is unknown is a valid report. | decided |
| V14 | When `verify` reveals a weakness in its own method, especially when a claim it marked verified later turns out false, it **offers** to file an issue on this repo and never files one by itself. Taking design ideas from other issue-filing skills is fine; copying or depending on them is not. | decided |

### Communication

| ID | Decision | Status |
|---|---|---|
| C1 | Top-down communication is a plain-text convention, `COMMUNICATION.md`, owned by `system-map`. | decided |
| C2 | Output styles aren't used for it, because they can't be limited to a skill and only work in Claude Code (see Facts). | decided |
| C3 | Pointing to these conventions from the maintainer's own global instructions is a personal choice. Nobody using the skills needs it. | proposed |

### Reuse

| ID | Decision | Status |
|---|---|---|
| U1 | Reuse `grilling`, `domain-modeling` and `codebase-design` from the maintainer's dotfiles. Their origin was verified: each matches a commit of `mattpocock/skills` byte for byte (`170ad48`, `ee8bae4`, `ee8bae4`). | proposed |
| U2 | Which `grilling` to use: the local version (one question at a time) or the current upstream version (numbered rounds of every question that's ready to ask). | open |
| U3 | Upstream `domain-modeling` renamed `CONTEXT.md` to `GLOSSARY.md`. Which name to follow. | open |
| U4 | `research` overlaps with `verify`: rebuild it on `CERTAINTY.md`, replace it, or leave it. | open |

## Working method

| ID | Decision | Status |
|---|---|---|
| W1 | Autonomous runs between checkpoints. Paths are arranged so a stream is never blocked by a checkpoint in another stream. | decided |
| W2 | One worktree, branch and session per stream. Each session starts from these documents, never from "carry on from the other session". | decided |
| W3 | Streams only connect through work merged to `main`. | decided |
| W4 | Every `/goal` condition names a deterministic check whose output appears in the transcript, because the goal evaluator only judges the transcript (see Facts). | proposed |
| W5 | Merges are the maintainer's. Agents open PRs and never merge them. | decided |

## Facts relied on

Each was verified on 2026-11-27, by reading the source named. Check again before
relying on one later: anything time-sensitive here may have changed.

| Fact | Source |
|---|---|
| Claude Code's auto memory is stored per checkout path, so git worktrees don't share it. | Read: the memory path of a live session |
| Claude Code reads `AGENTS.md` natively only when no `CLAUDE.md` exists in the working directory or its parents. | Read: code.claude.com/docs/en/memory |
| The built-in Explore, Plan and web-fetch agents load no `CLAUDE.md`. Other subagents do. | Read: code.claude.com/docs/en/sub-agents |
| Output styles have no skill frontmatter field. A plugin can force one on, but only for as long as it's enabled. They are not part of the Agent Skills standard. | Read: code.claude.com/docs/en/output-styles, /skills, agentskills.io/specification |
| The `/goal` evaluator "doesn't run commands or read files independently". It judges the transcript and has no step that pauses for approval. | Read: code.claude.com/docs/en/goal |
| Workflows accept no user input mid-run. Agent teams are experimental and token-heavy. | Read: code.claude.com/docs/en/workflows, /agent-teams |
| OpenSpec doesn't mention EARS. Searched all 1,390 tracked files at `f1cd852`, with a positive control (`SHALL` was found 7 times in `docs/writing-specs.md`). Its issues and discussions weren't searched. | Ran |
| EARS: five patterns and their clause order, from its author's page. The page says nothing about acceptance criteria. | Read: alistairmavin.com/ears |
