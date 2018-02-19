module Struct.CharacterTurn exposing
   (
      Type,
      State(..),
      add_target,
      can_select_targets,
      get_path,
      get_state,
      get_targets,
      lock_path,
      new,
      remove_target,
      set_active_character,
      set_navigator,
      try_getting_active_character,
      try_getting_navigator
   )

-- Elm -------------------------------------------------------------------------
import List

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Direction
import Struct.Navigator

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type State =
   Default
   | SelectedCharacter
   | MovedCharacter
   | ChoseTarget

type alias Type =
   {
      state : State,
      active_character : (Maybe Struct.Character.Type),
      path : (List Struct.Direction.Type),
      targets : (List Struct.Character.Ref),
      navigator : (Maybe Struct.Navigator.Type)
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
      targets = [],
      navigator = Nothing
   }

try_getting_active_character : Type -> (Maybe Struct.Character.Type)
try_getting_active_character ct = ct.active_character


can_select_targets : Type -> Bool
can_select_targets ct =
   ((ct.state == MovedCharacter) || ((ct.state == ChoseTarget)))

set_active_character : (
      Type ->
      Struct.Character.Type ->
      Type
   )
set_active_character ct char =
   {ct |
      state = SelectedCharacter,
      active_character = (Just char),
      path = [],
      targets = [],
      navigator = Nothing
   }

get_state : Type -> State
get_state ct = ct.state

get_path : Type -> (List Struct.Direction.Type)
get_path ct = ct.path

lock_path : Type -> Type
lock_path ct =
   case ct.navigator of
      (Just old_nav) ->
         {ct |
            state = MovedCharacter,
            path = (Struct.Navigator.get_path old_nav),
            targets = [],
            navigator = (Just (Struct.Navigator.lock_path old_nav))
         }

      Nothing ->
         ct

try_getting_navigator : Type -> (Maybe Struct.Navigator.Type)
try_getting_navigator ct = ct.navigator

set_navigator : Type -> Struct.Navigator.Type -> Type
set_navigator ct navigator =
   {ct |
      state = SelectedCharacter,
      path = [],
      targets = [],
      navigator = (Just navigator)
   }

add_target : Type -> Struct.Character.Ref -> Type
add_target ct target_ref =
   {ct |
      state = ChoseTarget,
      targets = (List.append ct.targets [target_ref])
   }

remove_target : Type -> Int -> Type
remove_target ct i =
   let
      new_targets = (List.drop i ct.targets)
   in
      case new_targets of
         [] ->
            {ct |
               state = MovedCharacter,
               targets = []
            }

         _ ->
            {ct |
               state = ChoseTarget,
               targets = new_targets
            }

get_targets : Type -> (List Struct.Character.Ref)
get_targets ct = ct.targets
