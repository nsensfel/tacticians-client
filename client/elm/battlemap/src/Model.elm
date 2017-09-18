module Model exposing (Model, model)

import Battlemap as Bp exposing (Battlemap, random, apply_to_all_tiles)
import Battlemap.Navigator as Nr exposing (Navigator, new_navigator)

import Character exposing (Character, CharacterRef)

import Dict exposing (Dict, empty, insert)

-- MODEL
type alias Model =
   {
      battlemap: Bp.Battlemap,
      navigator: (Maybe Nr.Navigator),
      selection: (Maybe String),
      characters: (Dict CharacterRef Character)
   }

model : Model
model =
   {
      battlemap = (Bp.random),
      navigator = Nothing,
      selection = Nothing,
      characters =
         (insert
            "2"
            {
               id = "2",
               name = "Char2",
               icon = "Icon2",
               portrait = "Portrait2",
               x = 1,
               y = 4
            }
            (insert
               "1"
               {
                  id = "1",
                  name = "Char1",
                  icon = "Icon1",
                  portrait = "Portrait1",
                  x = 4,
                  y = 1
               }
               (insert
                  "0"
                  {
                     id = "0",
                     name = "Char0",
                     icon = "Icon0",
                     portrait = "Portrait0",
                     x = 0,
                     y = 0
                  }
                  empty
               )
            )
         )
   }
