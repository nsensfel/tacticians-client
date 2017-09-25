module Model exposing (Type, State(..))

import Dict

import Battlemap
import Battlemap.Navigator
import Battlemap.Location
import Battlemap.RangeIndicator

import Character

type State =
   Default
   | MovingCharacter Character.Ref

-- MODEL
type alias Type =
   {
      state: State,
      battlemap: Battlemap.Type,
      navigator: (Maybe Battlemap.Navigator.Type),
      characters: (Dict.Dict Character.Ref Character.Type),
      range_indicator:
         (Dict.Dict
            Battlemap.Location.Ref
            Battlemap.RangeIndicator.Type
         )
   }
