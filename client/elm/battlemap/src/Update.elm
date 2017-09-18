module Update exposing (..)

import Model exposing (Model, model)

import Battlemap exposing (apply_to_all_tiles)
import Battlemap.Direction exposing (Direction)

import Battlemap.Navigator as Nr exposing (go, reset_navigation)

import Dict as Dt exposing (get)

import Character exposing (CharacterRef)

type Msg =
   DirectionRequest Direction
   | SelectCharacter CharacterRef

update : Msg -> Model -> Model
update msg model =
   case msg of
      (DirectionRequest d) ->
         (case model.selection of
            Nothing ->
               model
            (Just char_id) ->
               (case model.navigator of
                  Nothing -> model
                  (Just nav) ->
                     let
                        (new_bmap, new_nav) =
                           (Nr.go
                              model.battlemap
                              nav
                              d
                           )
                     in
                        {model |
                           battlemap = new_bmap,
                           navigator = (Just new_nav)
                        }
               )
         )
      (SelectCharacter char_id) ->
         {model |
            selection = (Just char_id),
            battlemap =
               (apply_to_all_tiles
                  model.battlemap
                  (reset_navigation)
               ),
            navigator =
               (case (Dt.get char_id model.characters) of
                  Nothing -> Nothing
                  (Just char) ->
                     (Just (Nr.new_navigator {x = char.x, y = char.y}))
               )
         }
      --_ -> model
