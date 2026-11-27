# Streams

Parallel streams of work, each with its own handover. Read the
[decision log](decision-log.md) and [ADR-0001](../adr/0001-wrap-openspec-format.md)
before starting any stream.

## Dependencies

```
                ┌─► S0  repo foundation ──────────────┬──────────────┐
                │                                     ▼              ▼
 handover PR ───┼─► S1a requirements-skill spec ──► S1b build    S2b verify ──► S2c system-map ──► S2d architecture-design
                │                                                    ▲
                └─► S2a verification specs ──────────────────────────┘
```

| Stream | Starts when | Kind | Branch |
|---|---|---|---|
| [S0](0-repo-foundation.md) | the handover PR is in place | autonomous `/goal` | `stream-0-repo-foundation` |
| [S1a](1-requirements-skill.md) | the handover PR is in place | autonomous draft, then **maintainer approval rounds** | `stream-1a-requirements-spec` |
| [S1b](1-requirements-skill.md#s1b-build) | S0 and S1a are merged | autonomous `/goal` | `stream-1b-requirements-build` |
| [S2a](2-verification-architecture.md) | the handover PR is in place | autonomous draft, then **maintainer approval rounds** | `stream-2a-verification-specs` |
| [S2b](2-verification-architecture.md#s2b-verify) | S0 and S2a are merged | autonomous `/goal` | `stream-2b-verify` |
| [S2c](2-verification-architecture.md#s2c-system-map) | S2b is merged | autonomous `/goal` | `stream-2c-system-map` |
| [S2d](2-verification-architecture.md#s2d-architecture-design) | S2c is merged | autonomous `/goal` | `stream-2d-architecture-design` |

S0, S1a and S2a run in parallel. A stream that reaches a checkpoint waits there.
The other streams keep going (W1).

**Base for the first three streams.** The handover docs are on the branch
`docs-stream-handovers` until that PR merges. So S0, S1a and S2a are cut from
that branch: an explicit base override, which needs no `--base` guess. Once the
handover PR merges, their diffs against `main` show only their own changes.
Every later stream is cut from `origin/main`.

## Rules for every stream

- **One worktree, one branch, one session.** Cut new worktrees from a freshly
  fetched `origin/main` (`git fetch origin`, then
  `git worktree add <worktree-root>/bearmoth/skills/<branch> -b <branch> origin/main`).
  Never work on a `main` checkout.
- **Start from documents.** This folder, the decision log and the ADRs are the
  whole brief. If a decision you need isn't there, **stop and ask** the
  maintainer. Don't guess (P1).
- **Stay in your files.** Running in parallel is only safe if streams don't edit
  the same files:

  | Owner | Files |
  |---|---|
  | S0 | `README.md`, `install*`, `.claude-plugin/`, `plugins/`, `skills/roast-me/`, the skill layout |
  | S1a, S1b | `openspec/specs/requirements/`, `skills/requirements/`, the lint script and its fixtures |
  | S2a | `openspec/specs/verify/`, `openspec/specs/system-map/`, `openspec/specs/architecture-design/` |
  | S2b, S2c, S2d | `skills/verify/`, `skills/system-map/`, `skills/architecture-design/` |
  | anyone | new files under `docs/adr/` (see numbering) |

  If you need to change a file owned by another stream, stop and ask.
- **ADR numbering.** Use the highest number on `origin/main` plus one. If two
  PRs collide, the one merged later renumbers.
- **Agents never merge** (W5). Finish by opening a PR against `main`. Its
  description lists every proposed decision you relied on and every one you
  added.
- **Never touch the live home directory.** Install tests run with `HOME` set to
  a fresh temporary folder. Installing for real is the maintainer's job, after
  merge.
- **Each `/goal` names a deterministic check** whose output is shown in the
  transcript (W4). A claim of "done" without that output doesn't count.
- **Stop conditions, in every run:** the turn limit in the goal. The same check
  failing 3 times in a row. A missing decision. Anything that would touch
  another stream's files, the network (other than reading public pages and
  repos), or the live home directory.

## Before an autonomous run: the five questions

Every handover answers these, following Claude Code's guidance for runs nobody
is watching: **done** (what finished looks like), **check** (how the agent proves
it), **scope** (what it may touch), **stop** (what halts it) and **sign-off**
(who approves before anything irreversible). The maintainer always signs off,
by reviewing and merging the PR.
