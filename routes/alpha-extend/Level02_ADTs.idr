-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 2: Algebraic Data Types
--
-- ACCEPT: Exhaustive pattern match compiles.
-- REJECT: Non-exhaustive match is a compile error (with --total).

module Level02_ADTs

data Shape = Circle Double | Rect Double Double

area : Shape -> Double
area (Circle r) = pi * r * r
area (Rect w h) = w * h  -- All constructors covered

-- REJECT (uncomment to see the error with --total):
-- areaPartial : Shape -> Double
-- areaPartial (Circle r) = pi * r * r
-- -- Missing: Rect case
-- -- Error: areaPartial is not total, missing case: Rect _ _

-- Verdict: ✓ PASS — Level 2 is native in Idris 2.
