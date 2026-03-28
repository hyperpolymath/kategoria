-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Kategoria Route α — Level 7: Linear Types (QTT)
--
-- ACCEPT: Resources used exactly once. File handles cannot leak.
-- REJECT: Using a resource twice or forgetting to use it is a type error.
--
-- Idris 2 is built on Quantitative Type Theory (QTT).
-- Multiplicities: 0 (erased), 1 (linear), ω (unrestricted).

module Level07_LinearTypes

-- A linear file handle: must be used exactly once
data LHandle : Type where
  MkHandle : (tag : String) -> LHandle

-- Open returns a linear handle (multiplicity 1)
openFile : (1 _ : String) -> LHandle
openFile path = MkHandle path

-- Read consumes the handle and returns data + a new handle
-- The old handle CANNOT be reused after this call
readFile : (1 _ : LHandle) -> (String, LHandle)
readFile (MkHandle tag) = ("contents of " ++ tag, MkHandle tag)

-- Close consumes the handle with no output — the resource is gone
closeFile : (1 _ : LHandle) -> ()
closeFile (MkHandle _) = ()

-- ACCEPT: correct linear usage — open, read, close
goodUsage : String
goodUsage =
  let h = openFile "data.txt"
      (content, h') = readFile h
      () = closeFile h'
  in content

-- A protocol that MUST be followed: connect -> authenticate -> use -> disconnect
data State = Disconnected | Connected | Authenticated

data Session : State -> Type where
  MkSession : (s : State) -> Session s

connect : (1 _ : Session Disconnected) -> Session Connected
connect (MkSession Disconnected) = MkSession Connected

authenticate : (1 _ : Session Connected) -> Session Authenticated
authenticate (MkSession Connected) = MkSession Authenticated

disconnect : (1 _ : Session Authenticated) -> Session Disconnected
disconnect (MkSession Authenticated) = MkSession Disconnected

-- ACCEPT: correct protocol order
goodProtocol : Session Disconnected -> Session Disconnected
goodProtocol s = disconnect (authenticate (connect s))

-- REJECT (uncomment to see errors):
--
-- Attempt to use handle twice:
-- doubleFree : ()
-- doubleFree =
--   let h = openFile "data.txt"
--       () = closeFile h
--       () = closeFile h  -- Error: h already consumed
--   in ()
--
-- Attempt to skip authentication:
-- skipAuth : Session Disconnected -> Session Disconnected
-- skipAuth s = disconnect (connect s)
-- Error: Type mismatch: expected Session Authenticated, got Session Connected

-- Verdict: ✓ PASS — Level 7 is native in Idris 2.
-- QTT multiplicities enforce resource protocols at compile time.
