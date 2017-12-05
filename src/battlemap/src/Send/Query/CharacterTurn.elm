module Query.CharacterTurn exposing
   (
      Type,
      State(..),
      new,
      try_getting_controlled_character,
      set_controlled_character,
      get_state,
      get_path,
      set_path,
      add_target,
      remove_target,
      get_targets
   )

-- Elm -------------------------------------------------------------------------
import List

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Direction

import UI

import Error

import Character

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
      controlled_character : (Maybe Character.Ref),
      path : (List Battlemap.Direction.Type),
      targets : (List Character.Ref)
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
      targets = []
   }

try_getting_controlled_character : Type -> (Maybe Character.Ref)
try_getting_controlled_character ct = ct.controlled_character

set_controlled_character : Type -> Character.Ref -> Type
set_controlled_character ct char_ref =
   {
      state = SelectedCharacter,
      controlled_character = (Just char_ref),
      path = [],
      targets = []
   }

get_state : Type -> State
get_state ct = ct.state

get_path : Type -> (List Battlemap.Direction.Type)
get_path ct = ct.path

set_path : Type -> (List Battlemap.Direction.Type) -> Type
set_path ct path =
   {ct |
      state = MovedCharacter,
      path = path,
      targets = []
   }

add_target : Type -> Character.Ref -> Type
add_target ct target_ref =
   {ct |
      state = ChoseTarget,
      targets = (List.append ct.targets [target_ref])
   }

remove_target : Type -> Int -> Type
remove_target ct i =
   let
      new_targets = (List.drop i ct.list)
   in
      case new_targets of
         [] ->
            {ct |
               state = MovedCharacter,
               path = path,
               targets = []
            }

         _ ->
            {ct |
               state = ChoseTarget,
               targets = new_targets
            }

get_targets : Type -> (List Character.Ref)
get_targets ct = ct.targets
