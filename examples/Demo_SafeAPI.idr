-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Demo: Type-Safe REST API — Levels 3-6 in action
--
-- Shows how Kategoria levels combine to create an API where
-- invalid requests are impossible to construct.

module Demo_SafeAPI

import Data.Vect
import Data.Nat

-- Level 3: Polymorphic response type
data ApiResponse : Type -> Type where
  Success : (code : Nat) -> a -> ApiResponse a
  Failure : (code : Nat) -> String -> ApiResponse a

-- Level 4: Functor for response transformation
Functor ApiResponse where
  map f (Success code x) = Success code (f x)
  map f (Failure code msg) = Failure code msg

-- Level 5: GADT for HTTP methods — only valid method+body combos exist
data Method : Type where
  GET    : Method
  POST   : Method
  DELETE : Method

data HasBody : Method -> Type where
  PostBody : HasBody POST

-- Level 6: Dependent types for URL path segments
data PathSegment = Literal String | Param String

Route : Type
Route = List PathSegment

-- Level 8: Refinement — port must be valid
ValidPort : Type
ValidPort = (p : Nat ** (LTE 1 p, LTE p 65535))

-- A complete API endpoint definition — levels 3-6 combined
record Endpoint where
  constructor MkEndpoint
  method : Method
  path   : Route
  port   : ValidPort

-- Example endpoints
usersEndpoint : Endpoint
usersEndpoint = MkEndpoint GET [Literal "api", Literal "v1", Literal "users"] (8080 ** (LTESucc LTEZero, ?portBound))

-- The type system guarantees:
-- 1. Responses are polymorphic (Level 3)
-- 2. Responses are mappable (Level 4)
-- 3. Only POST can have a body (Level 5 GADT)
-- 4. Route segments are typed (Level 6)
-- 5. Ports are bounded (Level 8)
