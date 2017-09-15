module Update exposing (..)

import Model exposing (Model, model)

import Battlemap.Direction exposing (..)

import Battlemap.Navigator as Nr exposing (go)

type Msg = DirectionRequest Direction | None

update : Msg -> Model -> Model
update msg model =
   case msg of
      (DirectionRequest d) ->
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
      _ -> model
