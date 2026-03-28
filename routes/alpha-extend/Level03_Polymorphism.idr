-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 3: Parametric Polymorphism
--
-- ACCEPT: Generic container operations work across types.
-- REJECT: Using type-specific operations on generic values is an error.
--
-- Idris 2 provides this natively via implicit type parameters.

module Level03_Polymorphism

-- A polymorphic identity function: works for ANY type
identity : a -> a
identity x = x

-- Polymorphic pair — works for any two types
data Pair : Type -> Type -> Type where
  MkPair : a -> b -> Pair a b

fst : Pair a b -> a
fst (MkPair x _) = x

snd : Pair a b -> b
snd (MkPair _ y) = y

-- ACCEPT: the same function works with different types
exampleInt : Int
exampleInt = identity 42

exampleStr : String
exampleStr = identity "hello"

examplePair : Pair Int String
examplePair = MkPair 42 "hello"

-- Polymorphic map over a simple list
data MyList : Type -> Type where
  Empty : MyList a
  Cons  : a -> MyList a -> MyList a

mapList : (a -> b) -> MyList a -> MyList b
mapList f Empty       = Empty
mapList f (Cons x xs) = Cons (f x) (mapList f xs)

-- ACCEPT: map with different function types
doubled : MyList Int
doubled = mapList (* 2) (Cons 1 (Cons 2 (Cons 3 Empty)))

lengths : MyList Nat
lengths = mapList length (Cons "hi" (Cons "world" Empty))

-- REJECT (uncomment to see the type error):
-- bad : Int
-- bad = identity 42 + identity "hello"
--
-- Error: Can't find an implementation for (+) with String
-- The polymorphism is PARAMETRIC — no type-specific operations leak through.

-- Verdict: ✓ PASS — Level 3 is native in Idris 2.
