-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 8: Refinement Types
--
-- ACCEPT: Only values satisfying a predicate are accepted.
-- REJECT: Values failing the predicate are compile-time errors.
--
-- Idris 2 encodes refinement types as dependent pairs (x : a ** p x).
-- Level 8 is not native but is idiomatically encodable.

module Level08_Refinement

import Data.Nat

-- Refinement type: a value paired with a proof of a property
-- {x : Nat | x > 0}  becomes  (x : Nat ** LTE 1 x)
Positive : Type
Positive = (n : Nat ** LTE 1 n)

-- Smart constructor: only succeeds when the value is positive
mkPositive : (n : Nat) -> {auto prf : LTE 1 n} -> Positive
mkPositive n {prf} = (n ** prf)

-- ACCEPT: 42 is positive (proof found automatically)
fortyTwo : Positive
fortyTwo = mkPositive 42

-- Division that REQUIRES a non-zero divisor at the type level
-- No runtime division-by-zero is possible
safeDivide : Nat -> (d : Nat ** LTE 1 d) -> Nat
safeDivide n (d ** _) = div n d

-- ACCEPT: dividing by 7 is fine
example1 : Nat
example1 = safeDivide 42 (mkPositive 7)  -- 6

-- Bounded integers: {x : Nat | x < bound}
Bounded : (bound : Nat) -> Type
Bounded bound = (n : Nat ** LT n bound)

-- Array index that CANNOT be out of bounds
data SafeArray : Nat -> Type -> Type where
  MkArray : Vect n a -> SafeArray n a

safeIndex : SafeArray n a -> Bounded n -> a
safeIndex (MkArray xs) (idx ** prf) = index (natToFinLT idx) xs

-- ACCEPT: valid index
exampleArray : SafeArray 3 String
exampleArray = MkArray ["hello", "world", "!"]

getFirst : String
getFirst = safeIndex exampleArray (0 ** LTESucc LTEZero)

-- Percentage: {x : Nat | x <= 100}
Percentage : Type
Percentage = (n : Nat ** LTE n 100)

mkPercentage : (n : Nat) -> {auto prf : LTE n 100} -> Percentage
mkPercentage n {prf} = (n ** prf)

-- ACCEPT: 85 is a valid percentage
grade : Percentage
grade = mkPercentage 85

-- REJECT (uncomment to see the type error):
-- badPositive : Positive
-- badPositive = mkPositive 0
--
-- Error: Can't find an implementation for LTE 1 0

-- REJECT:
-- badPercentage : Percentage
-- badPercentage = mkPercentage 101
--
-- Error: Can't find an implementation for LTE 101 100

-- Verdict: ✓ PASS — Level 8 is encodable in Idris 2.
-- Dependent pairs (x ** p x) give us refinement types with
-- compile-time predicate checking via auto-search.
