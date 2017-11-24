module Shim.Model exposing (generate)


import Dict

import Character

import UI

import Model

import Shim.Battlemap

new_char : (
      String ->
      Int ->
      Int ->
      Int ->
      Int ->
      Int ->
      (Dict.Dict Character.Ref Character.Type) ->
      (Dict.Dict Character.Ref Character.Type)
   )
new_char id team x y mp ad storage =
   (Dict.insert
      id
      {
         id = id,
         name = ("Char" ++ id),
         icon = id,
         team = team,
         portrait = id,
         location = {x = x, y = y},
         movement_points = mp,
         atk_dist = ad,
         enabled = (team == 0)
      }
      storage
   )

--generate : Model.Type
generate =
   {
      state = Model.Default,
      error = Nothing,
      battlemap = (Shim.Battlemap.generate),
      controlled_team = 0,
      player_id = "0",
      characters =
         (new_char "0"  0 0 0 7 0
         (new_char "1"  0 1 0 6 1
         (new_char "2"  1 2 7 5 2
         (new_char "3"  1 3 7 4 3
            Dict.empty
         )))),
--         (new_char "0"  0 0 0 7 0
--         (new_char "1"  0 1 0 6 1
--         (new_char "2"  0 2 0 5 1
--         (new_char "3"  0 3 0 4 2
--         (new_char "4"  0 4 0 3 2
--         (new_char "3"  0 3 0 2 3
--         (new_char "4"  0 4 0 1 3
--         (new_char "5"  1 0 7 7 0
--         (new_char "6"  1 1 7 6 1
--         (new_char "7"  1 2 7 5 1
--         (new_char "8"  1 3 7 4 2
--         (new_char "9"  1 4 7 3 2
--         (new_char "10" 1 3 7 2 3
--         (new_char "11" 1 4 7 1 3
--            Dict.empty
--         )))))))))))))),

      ui = (UI.default)
   }
