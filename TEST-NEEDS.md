# TEST-NEEDS.md — kategoria

## CRG Grade: C — ACHIEVED 2026-04-04

> Generated 2026-03-29 by punishing audit.

## Current State

| Category     | Count | Notes |
|-------------|-------|-------|
| Unit tests   | 0     | None |
| Integration  | 1     | Zig FFI integration_test.zig |
| E2E          | 0     | None |
| Benchmarks   | 0     | None |

**Source modules:** 3 Idris2 ABI (Types, Layout, Foreign), 1 Zig FFI, 10 Idris2 route levels (Level01-Level10), 3 example demos, 1 ReScript example. ~16 Idris2 files total, 3 Zig files.

## What's Missing

### P2P (Property-Based) Tests
- [ ] Type level route completeness: property tests that each level's types are well-formed
- [ ] ABI layout: property tests for struct alignment and size invariants
- [ ] FFI roundtrip: property tests for Idris2->Zig->Idris2 data integrity

### E2E Tests
- [ ] Full 10-level type progression: Level01 through Level10 compilation and verification
- [ ] Example execution: each demo (ProvenArithmetic, SafeAPI, StateMachine) runs to completion
- [ ] ABI/FFI round-trip: Idris2 definition -> C header -> Zig implementation -> verification

### Aspect Tests
- **Security:** No tests for type safety guarantees (the entire point of the project)
- **Performance:** No compilation time benchmarks for dependent type checking
- **Concurrency:** N/A for this project
- **Error handling:** No tests for malformed type definitions, invalid level progressions

### Build & Execution
- [ ] Idris2 compilation of all .idr files
- [ ] Zig build + test execution
- [ ] Example compilation verification

### Benchmarks Needed
- [ ] Type checking time per level (Level01-Level10)
- [ ] FFI call overhead measurement

### Self-Tests
- [ ] Type level proof verification (each level's proofs type-check)
- [ ] ABI version agreement between Idris2 and Zig

## Priority

**HIGH.** A type theory teaching tool with ZERO unit tests for 10 type levels is embarrassing. The single FFI integration test is not enough. Each of the 10 levels should have its own test suite proving the type-level guarantees actually hold.

## FAKE-FUZZ ALERT

- `tests/fuzz/placeholder.txt` is a scorecard placeholder inherited from rsr-template-repo — it does NOT provide real fuzz testing
- Replace with an actual fuzz harness (see rsr-template-repo/tests/fuzz/README.adoc) or remove the file
- Priority: P2 — creates false impression of fuzz coverage
