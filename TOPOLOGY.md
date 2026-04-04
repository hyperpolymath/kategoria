<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->

# TOPOLOGY.md — kategoria

## Purpose

Kategoria: The Type Safety Challenge. Five independent language implementations exploring all 10 known levels of type safety. Named after Aristotle's Categories (c. 350 BCE); explores deep relationship between ancient philosophy and modern type theory across 10 levels of safety that no single production language covers.

## Module Map

```
kategoria/
├── approach-1/
│   └── ... (Route 1 implementation toward 10 levels)
├── approach-2/
│   └── ... (Route 2 implementation)
├── approach-3/
│   └── ... (Route 3 implementation)
├── approach-4/
│   └── ... (Route 4 implementation)
├── approach-5/
│   └── ... (Route 5 implementation)
├── spec/
│   ├── type-safety-levels.adoc  # 10 levels of type safety
│   └── ... (design rationale)
├── README.adoc                  # Introduction and philosophy
└── LICENSE                      # PMPL-1.0-or-later
```

## Data Flow

```
[Aristotle's 10 Categories] ──► [Type Theory Parallels] ──► [5 Routes to Implementation]
                                                                    ↓
                                                    [Compare Coverage & Soundness]
```

## Key Invariants

- Five independent implementations avoid lock-in to single design
- Each approach documents which type-safety levels it covers
- Philosophy: explore type space rather than build one production language
- Aristotelian framing: systematic classification of fundamental concepts
