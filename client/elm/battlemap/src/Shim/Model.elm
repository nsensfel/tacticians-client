module Shim.Model exposing (generate)

import Dict

import Model

import Shim.Battlemap

--generate : Model.Type
generate =
   {
      state = Model.Default,
      battlemap = (Shim.Battlemap.generate),
      navigator = Nothing,
      characters =
         (Dict.insert
            "2"
            {
               id = "2",
               name = "Char2",
               icon = "Icon2",
               portrait = "Portrait2",
               location = {x = 0, y = 1},
               movement_points = 5,
               atk_dist = 1
            }
            (Dict.insert
               "1"
               {
                  id = "1",
                  name = "Char1",
                  icon = "Icon1",
                  portrait = "Portrait1",
                  location = {x = 1, y = 0},
                  movement_points = 4,
                  atk_dist = 2
               }
               (Dict.insert
                  "0"
                  {
                     id = "0",
                     name = "Char0",
                     icon = "Icon0",
                     portrait = "Portrait0",
                     location = {x = 0, y = 0},
                     movement_points = 3,
                     atk_dist = 1
                  }
                  Dict.empty
               )
            )
         ),
      range_indicator = Dict.empty
   }
