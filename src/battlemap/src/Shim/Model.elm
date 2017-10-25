module Shim.Model exposing (generate)

import Dict

import UI

import Model

import Shim.Battlemap

--generate : Model.Type
generate =
   {
      state = Model.Default,
      error = Nothing,
      battlemap = (Shim.Battlemap.generate),
      controlled_team = 0,
      characters =
         (Dict.insert
            "3"
            {
               id = "3",
               name = "Char3",
               icon = "3",
               team = 1,
               portrait = "3",
               location = {x = 3, y = 2},
               movement_points = 2,
               atk_dist = 4
            }
            (Dict.insert
               "2"
               {
                  id = "2",
                  name = "Char2",
                  icon = "2",
                  team = 1,
                  portrait = "2",
                  location = {x = 2, y = 2},
                  movement_points = 3,
                  atk_dist = 3
               }
               (Dict.insert
                  "1"
                  {
                     id = "1",
                     name = "Char1",
                     icon = "1",
                     team = 0,
                     portrait = "1",
                     location = {x = 1, y = 0},
                     movement_points = 4,
                     atk_dist = 2
                  }
                  (Dict.insert
                     "0"
                     {
                        id = "0",
                        name = "Char0",
                        icon = "0",
                        team = 0,
                        portrait = "0",
                        location = {x = 0, y = 0},
                        movement_points = 5,
                        atk_dist = 1
                     }
                     Dict.empty
                  )
               )
            )
         ),
      ui = (UI.default)
   }
