module Update exposing (update, Msg(..))

import Model exposing (Model, model)

import Battlemap exposing (apply_to_all_tiles, apply_to_tile_unsafe)
import Battlemap.Direction exposing (Direction)

import Battlemap.Navigator as Nr exposing (go, reset_navigation)

import Dict as Dt exposing (get, update)

import Character exposing (CharacterRef)


type Msg =
   DirectionRequest Direction
   | SelectCharacter CharacterRef
   | EndTurn

handle_direction_request : Model -> Direction -> Model
handle_direction_request model dir =
   (case (model.selection, model.navigator) of
      (Nothing, _) -> model
      (_ , Nothing) -> model
      ((Just char_id), (Just nav)) ->
         let
            (new_bmap, new_nav) =
               (Nr.go
                  model.battlemap
                  nav
                  dir
               )
         in
            {model |
               battlemap = new_bmap,
               navigator = (Just new_nav)
            }
   )

handle_select_character : Model -> CharacterRef -> Model
handle_select_character model char_id =
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
               (Just (Nr.new_navigator char.location))
         )
   }

handle_end_turn : Model -> Model
handle_end_turn model =
   case (model.navigator, model.selection) of
      (_, Nothing) -> model
      (Nothing, _) -> model
      ((Just nav), (Just char_id)) ->
         (case (Dt.get char_id model.characters) of
            Nothing -> model
            (Just char) ->
               {model |
                  navigator =
                     (Just (Nr.new_navigator nav.current_location)),
                  battlemap =
                     (apply_to_all_tiles
                        (apply_to_tile_unsafe
                           (apply_to_tile_unsafe
                              model.battlemap
                              char.location
                              (\t -> {t | char_level = Nothing})
                           )
                           nav.current_location
                           (\t -> {t | char_level = (Just char_id)})
                        )
                        (reset_navigation)
                     ),
                  characters =
                     (Dt.update
                        char_id
                        (\mc ->
                           case mc of
                              Nothing -> Nothing
                              (Just c) ->
                                 (Just {c | location = nav.current_location})
                        )
                        model.characters
                     )
               }
         )

update : Msg -> Model -> Model
update msg model =
   case msg of
      (DirectionRequest d) ->
         (handle_direction_request model d)
      (SelectCharacter char_id) ->
         (handle_select_character model char_id)
      EndTurn ->
         (handle_end_turn model)
      --_ -> model
