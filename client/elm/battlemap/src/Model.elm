module Model exposing (Type)

import Dict

import Battlemap
import Battlemap.Navigator
import Battlemap.Location
import Battlemap.RangeIndicator

import Character

import Shim.Model

-- MODEL
type alias Type =
   {
      battlemap: Battlemap.Type,
      navigator: (Maybe Battlemap.Navigator.Type),
      selection: (Maybe String),
      characters: (Dict.Dict Character.Ref Character.Type),
      range_indicator:
         (Dict.Dict
            Battlemap.Location.Ref
            Battlemap.RangeIndicator.Type
         )
   }

model : Type
model = (Shim.Model.generate)
