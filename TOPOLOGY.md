<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->

# TOPOLOGY.md — kategoria

## Purpose

Kategoria: The Type Safety Challenge. Five independent language-implementation
routes exploring all 10 known levels of type safety. Named after Aristotle's
*Categories* (c. 350 BCE); explores the deep relationship between ancient
philosophy and modern type theory across 10 levels of safety that no single
production language covers.

## Module Map

```
kategoria/
├── routes/
│   └── alpha-extend/            # Route α: Extend Idris 2 (the only route with code)
│       ├── Level01_BasicTypes.idr … Level10_CubicalTypes.idr
│       │                        # 10 verified level modules — all pass idris2 --check
│       └── README.adoc
├── examples/                    # 3 verified demos (arithmetic, state machine, safe API)
│   ├── Demo_ProvenArithmetic.idr
│   ├── Demo_StateMachine.idr
│   └── Demo_SafeAPI.idr
├── scripts/
│   └── check-idris2-proofs.sh   # THE proof gate: 13 modules + axiom-smuggling scan;
│                                # hard-fails when idris2 is absent
├── src/                         # Reserved structure for future routes (mostly manifests)
│   ├── bridges/                 # Route δ bridge ABI definitions (empty; manifest only)
│   ├── interface/ffi/           # QUARANTINED: uninstantiated RSR template scaffold —
│   │                            # contains {{project}} placeholders, does NOT compile,
│   │                            # excluded from all gates. Instantiate or remove when
│   │                            # a route actually needs a C ABI.
│   └── aspects|contracts|core|definitions|errors/   # manifests, no code yet
├── docs/
│   ├── theory/                  # Formalisms incl. cubical-QTT incompatibility analysis
│   ├── methodology/             # Human+LLM field reports
│   └── …
├── PROOF-STATUS.adoc            # Measured verification state (13/13) + reproduce recipe
├── ROADMAP.adoc                 # Route-by-route progress
├── README.md                    # Challenge definition, the five routes, scorecard
└── LICENSE                      # MPL-2.0 (code); CC-BY-SA-4.0 (docs)
```

The `approach-1/ … approach-5/` and `spec/` directories described by earlier
revisions of this file never existed in this repository; the map above is the
measured layout (2026-07-21).

## Data Flow

```
[Aristotle's 10 Categories] ──► [Type Theory Parallels] ──► [5 Routes to Implementation]
                                                                    ↓
                                                    [Compare Coverage & Soundness]
                                                                    ↓
                                              [Feed: typell verification kernel
                                               (routes/delta-aggregate/TYPELL-BRIDGE.adoc)]
```

## Key Invariants

- Five independent routes avoid lock-in to a single design
- Each route documents which type-safety levels it covers — and which it
  provably cannot (route α's L10 wall is recorded, not hidden)
- Every claimed proof is enforced by `scripts/check-idris2-proofs.sh`:
  no postulates, no believe_me, no %hint smuggling, no skipping when the
  prover is missing
- Philosophy: explore the type-space rather than build one production language
- Aristotelian framing: systematic classification of fundamental concepts
