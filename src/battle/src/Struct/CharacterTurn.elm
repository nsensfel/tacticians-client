module Struct.CharacterTurn exposing
   (
      Type,
      State(..),
      set_target,
      can_select_target,
      set_has_switched_weapons,
      has_switched_weapons,
      get_path,
      get_state,
      try_getting_target,
      lock_path,
      unlock_path,
      show_attack_range_navigator,
      new,
      set_active_character,
      set_active_character_no_reset,
      set_navigator,
      try_getting_active_character,
      try_getting_navigator
   )

-- Elm -------------------------------------------------------------------------

-- Battle ----------------------------------------------------------------------
import Struct.Character
import Struct.Direction
import Struct.Location
import Struct.Navigator
import Struct.Omnimods

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type State =
   Default
   | SelectedCharacter
   | MovedCharacter
   | ChoseTarget
   | SwitchedWeapons

type alias Type =
   {
      state : State,
      active_character : (Maybe Struct.Character.Type),
      path : (List Struct.Direction.Type),
      target : (Maybe Int),
      navigator : (Maybe Struct.Navigator.Type),
      has_switched_weapons : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      state = Default,
      active_character = Nothing,
      path = [],
      target = Nothing,
      navigator = Nothing,
      has_switched_weapons = False
   }

try_getting_active_character : Type -> (Maybe Struct.Character.Type)
try_getting_active_character ct = ct.active_character

can_select_target : Type -> Bool
can_select_target ct = (ct.state == MovedCharacter)

set_active_character : (
      Struct.Character.Type ->
      Type ->
      Type
   )
set_active_character char ct =
   {ct |
      state = SelectedCharacter,
      active_character = (Just char),
      path = [],
      target = Nothing,
      navigator = Nothing,
      has_switched_weapons = False
   }

set_active_character_no_reset : (
      Struct.Character.Type ->
      Type ->
      Type
   )
set_active_character_no_reset char ct =
   {ct |
      active_character = (Just char)
   }

get_state : Type -> State
get_state ct = ct.state

get_path : Type -> (List Struct.Direction.Type)
get_path ct = ct.path

lock_path : (Struct.Location.Type -> Struct.Omnimods.Type) -> Type -> Type
lock_path tile_omnimods ct =
   case (ct.navigator, ct.active_character) of
      ((Just old_nav), (Just char)) ->
         let
            current_tile_omnimods =
               (tile_omnimods (Struct.Navigator.get_current_location old_nav))
         in
            {ct |
               active_character =
                  (Just
                     (Struct.Character.refresh_omnimods
                        (\e -> current_tile_omnimods)
                        char
                     )
                  ),
               state = MovedCharacter,
               path = (Struct.Navigator.get_path old_nav),
               target = Nothing,
               navigator = (Just (Struct.Navigator.lock_path old_nav))
            }

      (_, _) ->
         ct

unlock_path : (Struct.Location.Type -> Struct.Omnimods.Type) -> Type -> Type
unlock_path tile_omnimods ct =
   case (ct.navigator, ct.active_character) of
      ((Just old_nav), (Just char)) ->
         {ct |
            active_character =
               (Just (Struct.Character.refresh_omnimods (tile_omnimods) char)),
            state = MovedCharacter,
            target = Nothing,
            navigator = (Just (Struct.Navigator.unlock_path old_nav))
         }

      (_, _) ->
         ct

show_attack_range_navigator : Int -> Int -> Type -> Type
show_attack_range_navigator range_min range_max ct =
   case ct.navigator of
      Nothing -> ct

      (Just old_nav) ->
            {ct |
               state = MovedCharacter,
               path = (Struct.Navigator.get_path old_nav),
               target = Nothing,
               navigator =
                  (Just
                     (Struct.Navigator.lock_path_with_new_attack_ranges
                        range_min
                        range_max
                        old_nav
                     )
                  )
            }

try_getting_navigator : Type -> (Maybe Struct.Navigator.Type)
try_getting_navigator ct = ct.navigator

set_navigator : Struct.Navigator.Type -> Type -> Type
set_navigator navigator ct =
   {ct |
      state = SelectedCharacter,
      path = [],
      target = Nothing,
      navigator = (Just navigator)
   }

set_has_switched_weapons : Bool -> Type -> Type
set_has_switched_weapons v ct =
   {ct |
      has_switched_weapons = v,
      state =
         (
            if (v)
            then SwitchedWeapons
            else MovedCharacter
         )
   }

has_switched_weapons : Type -> Bool
has_switched_weapons ct = ct.has_switched_weapons

set_target : (Maybe Int) -> Type -> Type
set_target target ct =
   case target of
      Nothing ->
         {ct |
            state = MovedCharacter,
            target = target
         }

      _ ->
         {ct |
            state = ChoseTarget,
            target = target
         }

try_getting_target : Type -> (Maybe Int)
try_getting_target ct = ct.target
