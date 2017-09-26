module Model exposing (Type, CharacterSelection, State(..))

import Dict

import Battlemap
import Battlemap.Navigator
import Battlemap.Location
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
   | Error Error.Type
   | MovingCharacterWithButtons
   | MovingCharacterWithClick
   | FocusingTile

type alias Type =
   {
      state: State,
      battlemap: Battlemap.Type,
      characters: (Dict.Dict Character.Ref Character.Type),
      selection: (Maybe CharacterSelection)
   }
