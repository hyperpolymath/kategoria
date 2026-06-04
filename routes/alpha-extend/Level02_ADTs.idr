-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
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
