# S2: Verification and architecture skills

Three skills (A1, A7, V1):
- `verify`, a primitive that checks claims and reports how certain each one is;
- `system-map`, which maps an existing system top-down along C4 levels;
- `architecture-design`, which designs a new system or a change, level by level.

They share plain-text conventions: `CERTAINTY.md` and `METHODS.md` owned by
`verify`, and `COMMUNICATION.md` owned by `system-map`. Other skills refer to
them by skill name (P4).

## Inputs

- Decision log, sections **Principles**, **Verification and architecture skills**
  and **Working method**, plus **Facts relied on**.
- ADR-0001 for the requirements format. S1's lint doesn't exist yet, so S2a
  applies the format by hand (see S2a).

---

## S2a: Specs

**Branch:** `stream-2a-verification-specs` · **Kind:** autonomous draft, then
maintainer approval rounds · **Starts:** now · **Blocks:** S2b

S2a doesn't wait for S1. The format is already fixed by ADR-0001, and the
decision log already records which decisions were made, which is the job S1's
skill would do. When S1b's lint lands, run it on these specs and fix whatever it
flags. That follow-up doesn't block anything (W1).

### Five questions

- **Done:** these three files hold the requirements, each one marked
  **decided** or dropped, and a PR is open:
  - `openspec/specs/verify/spec.md`
  - `openspec/specs/system-map/spec.md`
  - `openspec/specs/architecture-design/spec.md`
- **Check:** before the first round, confirm by hand that every requirement
  follows the four rules in ADR-0001 and the R8 checks. Also run a fresh
  reviewer.
- **Scope:** only those three spec folders.
- **Stop:** after the autonomous part, wait for the maintainer. Also stop if a
  decision is missing from the log.
- **Sign-off:** the maintainer approves every requirement and merges the PR.

### Steps

1. **Autonomous.** Draft the three specs from the decision log, carrying each
   status across unchanged and never upgrading one. Give V10 and V13 the most
   scenarios. Every false-confidence failure needs a scenario that names the
   wrong outcome explicitly ("AND not 'verified: …'").
2. **Autonomous.** Start a fresh reviewer agent with only the three spec files,
   ADR-0001 and the decision log. Ask it to flag:
   - requirements that are really design decisions;
   - scenarios that only restate their requirement;
   - missing failure cases;
   - anywhere a skill could report certainty it doesn't have.
3. **Checkpoint.** Show the maintainer the reviewer's findings and the first
   round of proposed requirements, numbered, each with your recommendation, and
   worded so "yes" accepts it. Put the open items (U2–U4) in the first round.
   Repeat rounds until nothing is proposed.
4. Commit, then open the PR.

---

## S2b: verify

**Branch:** `stream-2b-verify` · **Starts:** when S0 and S2a are merged

Build `skills/verify/`: `SKILL.md`, `CERTAINTY.md`, `METHODS.md`, and evals taken
from `openspec/specs/verify/spec.md`. Use the same eval approach as S1b. If S1b
hasn't chosen one yet, use a plain script and say so in the PR. Never touch the
real state folder: tests set `XDG_STATE_HOME` to a temporary folder.

```
/goal All of the following hold, each shown by command output in this transcript:
(1) every scenario in openspec/specs/verify/spec.md has an eval case and the eval run shows them all passing;
(2) at least one eval gives verify a claim whose check cannot run, and its output shows "not checked: <reason>" and no "verified";
(3) at least one eval gives verify a claim about everything whose positive control fails, and its output shows "unknown";
(4) tests write per-repo knowledge only under a temp XDG_STATE_HOME (shown with ls);
(5) with HOME set to a new empty temp dir, the install script installs verify via the S0 layout;
(6) the work is committed on stream-2b-verify and a PR against main is open, not merged.
Or stop after 60 turns.
```

## S2c: system-map

**Branch:** `stream-2c-system-map` · **Starts:** when S2b is merged

Build `skills/system-map/` with `COMMUNICATION.md`, using `verify` for the
current-state map (A4). It uses the same goal shape as S2b: every scenario has
an eval and passes, the install test passes, and a PR is open. It adds one
check: an eval run on a small fixture repo shows a map whose every element
carries a certainty tag.

## S2d: architecture-design

**Branch:** `stream-2d-architecture-design` · **Starts:** when S2c is merged

Build `skills/architecture-design/`. It uses `system-map` for the starting map,
an empty map for new designs (A3), and the shared conventions. U2 (which
`grilling`) must be decided by then. It uses the same goal shape as S2b and S2c.
