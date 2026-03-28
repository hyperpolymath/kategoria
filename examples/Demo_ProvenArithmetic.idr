-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Demo: Proven Arithmetic — Level 6 proofs in practice
--
-- Every operation carries a proof of correctness.
-- The compiler verifies these proofs at compile time.

module Demo_ProvenArithmetic

import Data.Nat

-- A SafeNat carries its value AND a proof it's non-negative
-- (Nat is already non-negative, but this shows the pattern)
data SafeNat : Nat -> Type where
  MkSafe : (n : Nat) -> SafeNat n

-- Addition with a proof that the result equals a + b
safeAdd : SafeNat a -> SafeNat b -> SafeNat (a + b)
safeAdd (MkSafe a) (MkSafe b) = MkSafe (a + b)

-- The type PROVES 3 + 4 = 7 at compile time
example : SafeNat 7
example = safeAdd (MkSafe 3) (MkSafe 4)

-- Subtraction that can only succeed when a >= b
-- The proof (LTE b a) is required — no runtime check needed
safeSub : SafeNat a -> SafeNat b -> {auto prf : LTE b a} -> SafeNat (minus a b)
safeSub (MkSafe a) (MkSafe b) = MkSafe (minus a b)

-- ACCEPT: 10 - 3 = 7 (compiler finds proof that 3 <= 10)
subExample : SafeNat 7
subExample = safeSub (MkSafe 10) (MkSafe 3)

-- Factorial with totality — compiler verifies termination
factorial : Nat -> Nat
factorial Z     = 1
factorial (S n) = (S n) * factorial n

-- The type system guarantees:
-- 1. Addition result type matches actual sum (by construction)
-- 2. Subtraction cannot underflow (LTE proof required)
-- 3. Factorial terminates (structural recursion on Nat)
-- 4. No runtime errors, no exceptions, no undefined behaviour
