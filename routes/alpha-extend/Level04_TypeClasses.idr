-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 4: Type Classes (Interfaces) & Higher-Kinded Types
--
-- ACCEPT: Custom types implement Show, Eq, Functor. Constrained generics work.
-- REJECT: Calling interface methods on types that lack an implementation is an error.
--
-- Idris 2 calls these "interfaces" rather than type classes.

module Level04_TypeClasses

-- Define a custom type
data Colour = Red | Green | Blue

-- Implement the Show interface for Colour
Show Colour where
  show Red   = "Red"
  show Green = "Green"
  show Blue  = "Blue"

-- Implement Eq for Colour
Eq Colour where
  Red   == Red   = True
  Green == Green = True
  Blue  == Blue  = True
  _     == _     = False

-- ACCEPT: constrained generics — only accept types with Show
describe : Show a => a -> String
describe x = "The value is: " ++ show x

exampleDescribe : String
exampleDescribe = describe Red  -- "The value is: Red"

-- Higher-kinded types: Functor for our own container
data Box : Type -> Type where
  MkBox : a -> Box a

Functor Box where
  map f (MkBox x) = MkBox (f x)

-- ACCEPT: map works because Box implements Functor
doubled : Box Int
doubled = map (* 2) (MkBox 21)  -- MkBox 42

-- Custom interface with a default method
interface Describable a where
  name : a -> String
  fullDescription : a -> String
  fullDescription x = "Object: " ++ name x  -- default implementation

Describable Colour where
  name Red   = "red"
  name Green = "green"
  name Blue  = "blue"

-- Interface with superclass constraint
interface (Eq a, Show a) => Printable a where
  prettyPrint : a -> String

Printable Colour where
  prettyPrint c = "[" ++ show c ++ "]"

-- REJECT (uncomment to see the error):
-- data Secret = MkSecret Int
-- badShow : String
-- badShow = show (MkSecret 42)
--
-- Error: Can't find an implementation for Show Secret

-- Verdict: ✓ PASS — Level 4 is native in Idris 2.
-- Interfaces + higher-kinded types + constrained generics all work.
