-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 5: GADTs (Generalised Algebraic Data Types)
--
-- ACCEPT: Type-safe expression evaluator — ill-typed expressions cannot exist.
-- REJECT: Constructing an expression that adds an Int to a Bool is impossible.
--
-- Idris 2 supports GADTs via indexed data types.

module Level05_GADTs

-- A type-safe expression language.
-- The type parameter 'a' tracks what the expression evaluates to.
data Expr : Type -> Type where
  LitInt    : Int -> Expr Int
  LitBool   : Bool -> Expr Bool
  LitString : String -> Expr String
  Add       : Expr Int -> Expr Int -> Expr Int
  And       : Expr Bool -> Expr Bool -> Expr Bool
  IfThenElse : Expr Bool -> Expr a -> Expr a -> Expr a
  Equal     : Eq a => Expr a -> Expr a -> Expr Bool

-- A type-safe evaluator — total, no runtime type errors possible.
eval : Expr a -> a
eval (LitInt n)        = n
eval (LitBool b)       = b
eval (LitString s)     = s
eval (Add x y)         = eval x + eval y
eval (And x y)         = eval x && eval y
eval (IfThenElse c t f) = if eval c then eval t else eval f
eval (Equal x y)       = eval x == eval y

-- ACCEPT: well-typed expressions
expr1 : Expr Int
expr1 = Add (LitInt 1) (LitInt 2)

result1 : Int
result1 = eval expr1  -- 3

expr2 : Expr Bool
expr2 = And (LitBool True) (Equal (LitInt 5) (LitInt 5))

result2 : Bool
result2 = eval expr2  -- True

-- Conditional with matching branches
expr3 : Expr Int
expr3 = IfThenElse (LitBool True) (LitInt 42) (Add (LitInt 1) (LitInt 2))

result3 : Int
result3 = eval expr3  -- 42

-- REJECT (uncomment to see the type error):
-- badExpr : Expr Int
-- badExpr = Add (LitInt 1) (LitBool True)
--
-- Error: Type mismatch: expected Expr Int, got Expr Bool
-- The GADT index prevents mixing types in Add.

-- REJECT: mismatched if branches
-- badIf : Expr Int
-- badIf = IfThenElse (LitBool True) (LitInt 42) (LitBool False)
--
-- Error: Type mismatch: expected Expr Int, got Expr Bool

-- Verdict: ✓ PASS — Level 5 is native in Idris 2.
-- GADTs via indexed types give us type-safe DSLs with zero runtime overhead.
