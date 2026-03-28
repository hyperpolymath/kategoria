-- SPDX-License-Identifier: PMPL-1.0-or-later
-- Demo: Type-Safe State Machine — Levels 5-7 in action
--
-- A vending machine where the type system prevents invalid transitions.
-- You cannot dispense before paying, and you cannot pay twice.

module Demo_StateMachine

-- Level 5: GADT for machine states
data MachineState = Idle | HasMoney | Dispensing

-- Level 6: Dependent type indexed by state
data VendingMachine : MachineState -> Type where
  MkMachine : (state : MachineState) -> (balance : Nat) -> VendingMachine state

-- Level 7: Linear transitions — each machine value consumed exactly once
insertCoin : (1 _ : VendingMachine Idle) -> VendingMachine HasMoney
insertCoin (MkMachine Idle _) = MkMachine HasMoney 100

selectItem : (1 _ : VendingMachine HasMoney) -> VendingMachine Dispensing
selectItem (MkMachine HasMoney bal) = MkMachine Dispensing bal

dispense : (1 _ : VendingMachine Dispensing) -> (String, VendingMachine Idle)
dispense (MkMachine Dispensing _) = ("Enjoy your snack!", MkMachine Idle 0)

-- ACCEPT: valid sequence
buySnack : VendingMachine Idle -> (String, VendingMachine Idle)
buySnack m =
  let m1 = insertCoin m
      m2 = selectItem m1
  in dispense m2

-- The type system prevents:
--
-- 1. Dispensing without paying:
--    bad1 = dispense (MkMachine Idle 0)
--    Error: expected VendingMachine Dispensing, got VendingMachine Idle
--
-- 2. Paying twice:
--    bad2 m = insertCoin (insertCoin m)
--    Error: expected VendingMachine Idle, got VendingMachine HasMoney
--
-- 3. Skipping item selection:
--    bad3 m = dispense (insertCoin m)
--    Error: expected VendingMachine Dispensing, got VendingMachine HasMoney
