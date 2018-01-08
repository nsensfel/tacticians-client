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
      set_controlled_character,
      set_navigator,
      try_getting_controlled_character,
      try_getting_navigator
   )

-- Elm -------------------------------------------------------------------------
import List

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.Direction
import Struct.Error
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
      controlled_character : (Maybe Struct.Character.Ref),
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
      controlled_character = Nothing,
      path = [],
      targets = [],
      navigator = Nothing
   }

try_getting_controlled_character : Type -> (Maybe Struct.Character.Ref)
try_getting_controlled_character ct = ct.controlled_character


can_select_targets : Type -> Bool
can_select_targets ct =
   ((ct.state == MovedCharacter) || ((ct.state == ChoseTarget)))

set_controlled_character : (
      Type ->
      Struct.Character.Type ->
      Type
   )
set_controlled_character ct char =
   {ct |
      state = SelectedCharacter,
      controlled_character = (Just (Struct.Character.get_ref char)),
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
