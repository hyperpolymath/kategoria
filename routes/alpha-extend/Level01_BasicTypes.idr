-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-- Kategoria Route α — Level 1: Basic Types
--
-- ACCEPT: Int arithmetic compiles. String operations compile.
-- REJECT: Int + String is a type error.
--
-- Idris 2 provides this natively. There is nothing to build.

module Level01_BasicTypes

-- ACCEPT: same-type operations
addInts : Int -> Int -> Int
addInts x y = x + y

concatStrings : String -> String -> String
concatStrings x y = x ++ y

example : Int
example = addInts 40 2  -- 42

-- REJECT (uncomment to see the type error):
-- bad : Int
-- bad = addInts 1 "hello"
--
-- Error: Can't find an implementation for FromString Int
-- (or: Type mismatch: expected Int, got String)

-- Verdict: ✓ PASS — Level 1 is native in Idris 2.
