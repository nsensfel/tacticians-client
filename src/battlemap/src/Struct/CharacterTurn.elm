module Struct.CharacterTurn exposing
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

set_controlled_character : (
      Type ->
      Struct.Character.Type ->
      (Struct.Location.Type -> Int) ->
      Type
)
set_controlled_character ct char mov_cost_fun =
   {
      state = SelectedCharacter,
      controlled_character = (Just (Struct.Character.get_ref char)),
      path = [],
      targets = [],
      navigator =
         (Just
            (Struct.Navigator.new
               (Struct.Character.get_location char)
               (Struct.Character.get_movement_points char)
               (Struct.Character.get_attack_range char)
               mov_cost_fun
            )
         )
   }

get_state : Type -> State
get_state ct = ct.state

get_path : Type -> (List Struct.Direction.Type)
get_path ct = ct.path

try_locking_path : Type -> (Just Type)
try_locking_path ct =
   case ct.navigator of
      (Just old_nav) ->
         {ct |
            state = MovedCharacter,
            path = (Struct.Navigator.get_path old_nav),
            targets = [],
            navigator =
               (Just
                  (Struct.Navigator.new
                     (Struct.Navigator.get_current_location old_nav)
                     0
                     (Struct.Character.get_attack_range char)
                     mov_cost_fun
                  )
               )
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
