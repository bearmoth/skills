# S1: Requirements skill

A reusable skill (R9, proposed name `requirements`, R12) that writes and checks
requirements in the format chosen in [ADR-0001](../adr/0001-wrap-openspec-format.md):
an EARS sentence plus OpenSpec-style scenarios, a status on every requirement,
and a deterministic lint.

The skill can't write its own requirements, because it doesn't exist yet. So S1a
writes them **by hand**, in the format. That also makes them the format's first
real test.

## Inputs

- ADR-0001, and decision log R1–R13, P1–P5.
- An example of the combined format: the "positive control for exhaustive
  claims" example. Four requirements, one per behavior, each with a scenario.
  One scenario states the wrong outcome explicitly ("AND not 'verified: no
  writers found'"), which is what makes a false-confidence failure catchable by
  a test. Copy that style.

---

## S1a: Spec

**Branch:** `stream-1a-requirements-spec` · **Kind:** autonomous draft, then
maintainer approval rounds · **Starts:** now · **Blocks:** S1b

### Five questions

- **Done:** `openspec/specs/requirements/spec.md` (R10) contains the skill's
  requirements. Every requirement is marked **decided** (the maintainer approved
  it) or has been dropped. A PR is open.
- **Check:** before the first round, confirm by hand that each requirement
  follows the four lint rules (R8), since no lint exists yet. Run a fresh
  reviewer (below), and confirm R10's path by reading OpenSpec's source.
- **Scope:** only `openspec/specs/requirements/`. Don't install OpenSpec.
- **Stop:** after the autonomous part, wait for the maintainer. Also stop if a
  decision is missing from the log.
- **Sign-off:** the maintainer approves every requirement and merges the PR.

### Steps

1. **Autonomous.** Draft the spec from the decision log. Carry each decision's
   status across unchanged: a decided item becomes a decided requirement, a
   proposed item becomes a proposed one. Never upgrade a status. The
   requirements cover:
   - the format and its four rules;
   - the four lint checks, plus a positive control for the lint itself: one bad
     example per check, which the lint must reject;
   - the creation process (R7): draft, mark, fresh review, rounds;
   - deltas (R11);
   - optional compatibility with `openspec validate`.
2. **Autonomous.** Confirm R10 by reading which paths OpenSpec's validator reads,
   in its source code (public repo `Fission-AI/OpenSpec`). Record the commit you
   read.
3. **Autonomous.** Start a fresh reviewer agent. Give it only the spec file,
   ADR-0001 and the decision log, never your own reasoning. Ask it to flag:
   requirements that don't follow the rules; requirements that are really
   design decisions; scenarios that only restate their requirement; missing
   failure cases.
4. **Checkpoint.** Show the maintainer the reviewer's findings and the first
   round of proposed requirements, numbered, each with your recommendation, and
   worded so "yes" accepts the recommendation. Then repeat rounds until nothing
   is proposed.
5. Commit, then open the PR.

---

## S1b: Build

**Branch:** `stream-1b-requirements-build` · **Kind:** autonomous `/goal` ·
**Starts:** when S0 and S1a are merged (cut from `origin/main` then)

Build the lint script (R13), `skills/requirements/SKILL.md`, and evals taken from
the spec's scenarios. Choosing an eval runner is part of this stream. If none can
be verified as trustworthy (P2), the evals run as a plain script, and that limit
is written in the PR.

```
/goal All of the following hold, each shown by command output in this transcript:
(1) the lint exits 0 on every openspec/specs/*/spec.md on this branch;
(2) the lint exits non-zero on each bad fixture (one per check, at least 4), naming the failed check;
(3) every scenario in openspec/specs/requirements/spec.md has an eval case, and the eval run shows them all passing;
(4) with HOME set to a new empty temp dir, the repo's install script installs the requirements skill via the S0 symlink layout;
(5) the work is committed on stream-1b-requirements-build and a PR against main is open, not merged.
Or stop after 60 turns.
```
