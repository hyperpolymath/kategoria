-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
--
-- Kategoria Route α — Level 10: Cubical / Homotopy Types
--
-- STATUS: ✗ IMPOSSIBLE on this route (QTT core ≠ cubical core).
--
-- This file documents:
--   1. WHAT Level 10 requires (univalence, transport, paths)
--   2. WHY Route α cannot achieve it (fundamental core mismatch)
--   3. WHAT we CAN do (setoid-style best effort)
--   4. WHERE to go instead (Routes β, δ, ε)
--
-- This is an honest engineering document, not a workaround.
-- Route α hits the wall here. That's valuable data.

module Level10_CubicalTypes

%default total

------------------------------------------------------------------------
-- What Level 10 Requires
------------------------------------------------------------------------

-- Cubical type theory (Cohen, Coquand, Huber, Mörtberg 2018) extends
-- Martin-Löf type theory with:
--
-- 1. PATHS: A type `Path A a b` (written `a ≡ b`) representing
--    a continuous function from the interval [0,1] into type A,
--    where f(0) = a and f(1) = b.
--
-- 2. TRANSPORT: Given a path `p : A ≡ B`, convert values:
--    `transport p : A -> B`
--
-- 3. UNIVALENCE (Voevodsky): Type equivalence IS type equality:
--    `ua : (A ≃ B) -> (A ≡ B)`
--    This is an AXIOM in HoTT but COMPUTES in cubical type theory.
--
-- 4. HIGHER INDUCTIVE TYPES: Types with path constructors, e.g.
--    the circle S¹ with a point `base` and a loop `loop : base ≡ base`.
--
-- The ACCEPT challenge (from CHALLENGES.adoc):
--   - `boolEquiv : (Bool ≃ Bool) ≃ Bool` — provable
--   - `transport : A ≡ B -> A -> B` — computes
--   - `ua : A ≃ B -> A ≡ B` — univalence
--
-- The REJECT challenge:
--   - `bad : Nat ≡ Bool` — must reject (no equivalence exists)

------------------------------------------------------------------------
-- The Wall: QTT ≠ Cubical
------------------------------------------------------------------------

-- Idris 2's core is Quantitative Type Theory (Atkey 2018, McBride 2016).
-- QTT tracks how many times a variable is used (0, 1, ω) but says
-- nothing about the IDENTITY of types.
--
-- Cubical type theory operates on a fundamentally different core:
--
-- | Feature              | QTT (Idris 2)         | Cubical (Agda --cubical) |
-- |----------------------|-----------------------|--------------------------|
-- | Equality             | Propositional (≡)     | Path types (I → A)       |
-- | Interval type        | None                  | I with 0, 1 endpoints    |
-- | Transport            | Manual proofs         | Primitive operation      |
-- | Univalence           | Cannot state it       | Axiom that computes      |
-- | Function extensionality | Postulate or deny  | Follows from paths       |
-- | Higher inductive types | Cannot define        | First-class              |
-- | Computation          | Definitional equality | Kan operations           |
--
-- The interval type I is not a type in QTT's universe. You cannot
-- add it without changing the core calculus. This is not a limitation
-- of Idris 2's implementation — it's a fundamental architectural
-- incompatibility.
--
-- Attempting to "fake" cubical types in QTT produces:
-- - Setoid-style equality: works but loses univalence
-- - Postulated univalence: axiom that doesn't compute (defeats purpose)
-- - Reflection-based tricks: can't create new definitional equalities

------------------------------------------------------------------------
-- Best Effort: What QTT CAN Express
------------------------------------------------------------------------

-- We demonstrate the fragment of L10 concepts that ARE expressible
-- in QTT, making clear what is lost.

||| Type equivalence: a pair of inverse functions with proofs.
||| This is standard in any dependently-typed language (L6).
||| It does NOT give us univalence — it's just a record.
public export
record Equiv (a : Type) (b : Type) where
  constructor MkEquiv
  ||| Forward function
  to   : a -> b
  ||| Backward function
  from : b -> a
  ||| Round-trip proof: to ∘ from = id
  toFrom : (y : b) -> to (from y) = y
  ||| Round-trip proof: from ∘ to = id
  fromTo : (x : a) -> from (to x) = x

||| Bool ≃ Bool via the identity equivalence
public export
boolIdEquiv : Equiv Bool Bool
boolIdEquiv = MkEquiv id id (\y => Refl) (\x => Refl)

||| Bool ≃ Bool via negation
public export
boolNotEquiv : Equiv Bool Bool
boolNotEquiv = MkEquiv not not notNotId notNotId
  where
    notNotId : (x : Bool) -> not (not x) = x
    notNotId True  = Refl
    notNotId False = Refl

||| There are exactly two equivalences Bool ≃ Bool: id and not.
||| We can STATE this in QTT...
public export
data BoolAutoEquiv : Type where
  IsId  : BoolAutoEquiv
  IsNot : BoolAutoEquiv

||| ...and we can map each to its equivalence...
public export
toBoolEquiv : BoolAutoEquiv -> Equiv Bool Bool
toBoolEquiv IsId  = boolIdEquiv
toBoolEquiv IsNot = boolNotEquiv

||| ...but we CANNOT prove (Equiv Bool Bool) ≃ Bool
||| in a way that respects univalence, because QTT's propositional
||| equality (=) is not path equality (≡).
|||
||| In cubical Agda this would be:
|||   boolEquiv : (Bool ≃ Bool) ≃ Bool
|||   boolEquiv = isoToEquiv (iso to from toFrom fromTo)
|||     where to = ... from = ... (using ua and transport)
|||
||| In QTT we can only state a WEAKER claim:
||| "There is a bijection between BoolAutoEquiv and Bool."
||| This is NOT the same as (Equiv Bool Bool) ≃ Bool because
||| we cannot prove BoolAutoEquiv exhausts all equivalences
||| without function extensionality + univalence.
public export
boolAutoToBool : BoolAutoEquiv -> Bool
boolAutoToBool IsId  = True
boolAutoToBool IsNot = False

public export
boolToBoolAuto : Bool -> BoolAutoEquiv
boolToBoolAuto True  = IsId
boolToBoolAuto False = IsNot

||| Round-trip proof (the easy direction)
public export
autoRoundtrip : (b : Bool) -> boolAutoToBool (boolToBoolAuto b) = b
autoRoundtrip True  = Refl
autoRoundtrip False = Refl

------------------------------------------------------------------------
-- What We Cannot Express
------------------------------------------------------------------------

-- 1. TRANSPORT
--
-- In cubical: transport : {A B : Type} -> A ≡ B -> A -> B
-- In QTT:     We can write `transport : a = b -> ...` but Idris 2's
--             `=` is propositional equality of VALUES, not types.
--             There is no built-in way to coerce values along a
--             type equality. We would need `believe_me` which is
--             unsafe and defeats the purpose.

-- 2. UNIVALENCE
--
-- ua : Equiv a b -> a = b
-- This CANNOT be stated in QTT. In Idris 2, `a = b` for types
-- would require `a` and `b` to be definitionally equal or provably
-- equal propositions. Type equivalence is a strictly weaker notion
-- than propositional equality in QTT.

-- 3. FUNCTION EXTENSIONALITY
--
-- funext : ((x : a) -> f x = g x) -> f = g
-- This is not provable in vanilla MLTT or QTT.
-- It CAN be postulated:
--
--   postulate funext : {f, g : a -> b} -> ((x : a) -> f x = g x) -> f = g
--
-- But postulates don't compute — `funext proof` is stuck, it never
-- reduces. In cubical type theory, funext is a theorem that computes.

-- 4. HIGHER INDUCTIVE TYPES
--
-- data S1 : Type where   -- The circle
--   base : S1
--   loop : base ≡ base   -- A PATH constructor
--
-- QTT has no path constructors. We cannot define S¹, the torus,
-- pushouts, or truncations as HITs. We can only approximate them
-- with quotient types (which Idris 2 also lacks natively).

------------------------------------------------------------------------
-- Comparison: Same Concept in Agda --cubical
------------------------------------------------------------------------

-- For reference, here is what L10 looks like in a language that
-- DOES have cubical types (Agda with --cubical flag):
--
-- open import Cubical.Foundations.Everything
-- open import Cubical.Data.Bool
--
-- -- Transport: coerce along a path
-- myTransport : {A B : Type} → A ≡ B → A → B
-- myTransport p a = transport (λ i → p i) a
--
-- -- Univalence: equivalence yields a path
-- myUa : {A B : Type} → A ≃ B → A ≡ B
-- myUa = ua
--
-- -- Bool ≃ Bool has exactly 2 elements (computes!)
-- boolEquiv : (Bool ≃ Bool) ≃ Bool
-- boolEquiv = isoToEquiv (iso
--   (λ e → fst e true)
--   (λ b → if b then idEquiv else notEquiv)
--   (λ { true → refl ; false → refl })
--   (λ e → equivEq (funExt (λ { true → ... ; false → ... }))))
--
-- -- REJECT: Nat ≡ Bool is uninhabited
-- -- bad : Nat ≡ Bool
-- -- bad = ?  -- No equivalence Nat ≃ Bool exists, so ua cannot help

------------------------------------------------------------------------
-- Route α Verdict
------------------------------------------------------------------------

-- ✗ IMPOSSIBLE — Level 10 cannot be achieved on Route α.
--
-- This is NOT a failure of implementation effort. It is a proven
-- architectural incompatibility:
--
-- 1. QTT's equality is propositional, not path-based
-- 2. QTT has no interval type I
-- 3. Without I, there are no path types
-- 4. Without path types, there is no transport or ua
-- 5. Without ua, univalence cannot be stated, let alone proved
--
-- This is the CORRECT outcome for Route α. The Five Routes
-- architecture (ADR-001) EXPECTED this wall. Routes that CAN
-- achieve L10:
--
--   Route β (Dyadic): Cubical checker as second core
--   Route δ (Aggregate): Bridge to Agda --cubical
--   Route ε (Clean Slate): New calculus unifying QTT + cubical
--
-- The question "can QTT and cubical coexist in one calculus?" is
-- an open research problem (Nuyts & Devriese 2023, Gratzer et al. 2024).
-- Route ε is the most ambitious attempt to answer it.
--
-- References:
-- - Cohen, Coquand, Huber, Mörtberg (2018) "Cubical Type Theory:
--   A Constructive Interpretation of the Univalence Axiom"
-- - Voevodsky (2010) "Univalent Foundations"
-- - The Univalent Foundations Program (2013) "Homotopy Type Theory"
-- - Nuyts & Devriese (2023) "Degrees of Relatedness"
-- - Gratzer, Kavvos, Nuyts, Birkedal (2024) "Multimodal Dependent
--   Type Theory" (towards unifying linear + cubical)
-- - Atkey (2018) "Syntax and Semantics of Quantitative Type Theory"
