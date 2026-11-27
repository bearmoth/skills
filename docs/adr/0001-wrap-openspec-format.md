---
status: accepted
date: 2026-11-27
---

# Wrap OpenSpec's requirement format; don't adopt its tool

Requirements in this repo are written in an OpenSpec-compatible format, with each
requirement sentence following an EARS pattern. A skill of our own produces and
checks them. We don't install or depend on the OpenSpec CLI or its workflow. The
reason: our rules must be enforced, not just advised, and nothing may become
"decided" without the maintainer's approval. OpenSpec's customisation points can't
give us either.

## Considered options

- **Adopt OpenSpec as is.** Rejected. Its `/opsx:propose` drafts requirements from
  a description. That is the "synthesize, don't ask" pattern, which turns
  inferences into requirements with no visible difference.
- **Bend OpenSpec** by forking its `spec-driven` schema and adding project `rules`.
  Rejected. Per its customisation docs, `context` and `rules` are injected into
  prompts, and "neither field is an enforceable check". Its validator is fixed: we
  found no documented way to add our own rules. EARS conformance and our status
  line would only be advice. It would also put a CLI installed with `curl | sh`,
  its workflow, and its generated `openspec-*` skills into a skills repo, none of
  them vetted.
- **Use an existing "conversation to spec" skill.** Rejected for the same
  synthesize-without-asking reason. It also publishes to an issue tracker
  without approval.
- **Wrap: use OpenSpec's format, with our own skill and lint.** Chosen.

## Consequences

- We maintain the requirements skill and a deterministic lint script.
- Files stay OpenSpec-compatible, so `openspec validate` works as an optional
  extra check, and adopting the tool later stays cheap. Compatibility depends
  on facts read in OpenSpec's source at commit `f1cd852` (2026-11-24). Check
  them again if you rely on them later:
  - The validator detects keywords with `/\b(SHALL|MUST)\b/`, which is
    case-sensitive (`src/core/parsers/requirement-text.ts`). So requirements
    write **SHALL** in capitals, even though EARS's own examples use "shall".
  - When the validator reads a requirement's text, it skips `**Name**:` lines
    as long as other text remains. So our status line uses the form
    `**Status**: … · **Source**: …`.
- Rules for combining the two formats:
  1. The EARS sentence states the general condition. Scenarios give specific
     cases and edge cases, never a restatement of the requirement.
  2. One response (one SHALL) per requirement, even though EARS allows several.
  3. SHALL in capitals.
  4. Status and source go in OpenSpec-style metadata lines.
