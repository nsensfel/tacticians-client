module Model exposing
   (
      Type,
      CharacterSelection,
      State(..),
      get_state,
      invalidate,
      reset,
      clear_error
   )

import Dict

import Battlemap
import Battlemap.Navigator
import Battlemap.Location
import Battlemap.Tile
import Battlemap.RangeIndicator

import Error

import Character

type alias CharacterSelection =
   {
      character: Character.Ref,
      navigator: Battlemap.Navigator.Type,
      range_indicator:
         (Dict.Dict
            Battlemap.Location.Ref
            Battlemap.RangeIndicator.Type
         )
   }

type State =
   Default
   | MovingCharacterWithButtons
   | MovingCharacterWithClick
   | FocusingTile

type alias Type =
   {
      state: State,
      battlemap: Battlemap.Type,
      characters: (Dict.Dict Character.Ref Character.Type),
      error: (Maybe Error.Type),
      selection: (Maybe CharacterSelection)
   }

get_state : Type -> State
get_state model = model.state

reset : Type -> Type
reset model =
   {model |
      state = Default,
      selection = Nothing,
      error = Nothing,
      battlemap =
         (Battlemap.apply_to_all_tiles
            model.battlemap
            (Battlemap.Tile.reset)
         )
   }

invalidate : Type -> Error.Type -> Type
invalidate model err = {model | error = (Just err)}

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
