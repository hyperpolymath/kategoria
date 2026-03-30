# PROOF-NEEDS.md — kategoria

## Current State

- **src/abi/*.idr**: NO
- **Dangerous patterns**: 1 `believe_me` in `Level09_SessionTypes.idr` (runtime placeholder for recv)
- **LOC**: ~4,400 (Idris2 routes + Nickel)
- **ABI layer**: Missing (but routes contain Idris2 type safety challenge levels)

## What Needs Proving

| Component | What | Why |
|-----------|------|-----|
| Session types (Level09) | Remove `believe_me` placeholder with real recv implementation | Current believe_me bypasses type checker for session receive |
| Cubical types (Level10) | Complete type equality proofs without believe_me | Level10 notes need for believe_me; should use proper cubical path types |
| Route completeness | All 5 routes (alpha-epsilon) have total, proven implementations | Challenge levels should themselves be provably correct |
| K9 contractile guards | believe_me/assert_total ceiling enforcement is sound | Meta-level: the guards themselves need correctness proofs |

## Recommended Prover

**Idris2** — The repo IS an Idris2 type safety challenge. The believe_me in Level09 is the primary proof gap. Level10 cubical types may benefit from **Agda** with cubical support.

## Priority

**MEDIUM** — Educational/challenge repo, but the believe_me in Level09 undermines the repo's own thesis. Fixing it would demonstrate the very point the challenge makes.

## Template ABI Cleanup (2026-03-29)

Template ABI removed -- was creating false impression of formal verification.
The removed files (Types.idr, Layout.idr, Foreign.idr) contained only RSR template
scaffolding with unresolved {{PROJECT}}/{{AUTHOR}} placeholders and no domain-specific proofs.
