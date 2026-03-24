-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 6: Dependent Types
--
-- ACCEPT: Length-indexed vector operations type-check.
-- REJECT: head on empty vector is a compile-time error.
--
-- This is Idris 2's core strength.

module Level06_DependentTypes

-- Length-indexed vector: the length is part of the type
data Vect : Nat -> Type -> Type where
  Nil  : Vect 0 a
  (::) : a -> Vect n a -> Vect (S n) a

-- Append preserves lengths (the type PROVES n + m = output length)
append : Vect n a -> Vect m a -> Vect (n + m) a
append Nil       ys = ys
append (x :: xs) ys = x :: append xs ys

-- Head can ONLY be called on non-empty vectors
-- The (S n) in the type makes Vect 0 a impossible as input
head : Vect (S n) a -> a
head (x :: _) = x

-- ACCEPT: this works because [1,2,3] has type Vect 3 Int
example : Int
example = head (1 :: 2 :: 3 :: Nil)

-- REJECT (uncomment to see the type error):
-- bad : Int
-- bad = head Nil
--
-- Error: Can't find an implementation for
--   0 = S ?n
-- (The compiler knows Nil has length 0, and head requires length S n.
--  0 ≠ S n for any n. This is a PROOF, not a runtime check.)

-- Bonus: zip requires EQUAL lengths — mismatched vectors won't compile
zip : Vect n a -> Vect n b -> Vect n (a, b)
zip Nil       Nil       = Nil
zip (x :: xs) (y :: ys) = (x, y) :: zip xs ys

-- REJECT (uncomment):
-- badZip : Vect 3 (Int, String)
-- badZip = zip (1 :: 2 :: 3 :: Nil) ("a" :: "b" :: Nil)
-- Error: Vect 2 String ≠ Vect 3 String

-- Verdict: ✓ PASS — Level 6 is native in Idris 2.
-- This is literally what Idris was built for.
