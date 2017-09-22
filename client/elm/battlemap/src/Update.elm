module Update exposing (update, Type(..))

import Model

import Battlemap
import Battlemap.Direction
import Battlemap.Navigator

import Dict

import Character

type Type =
   DirectionRequest Battlemap.Direction.Type
   | SelectCharacter Character.Ref
   | EndTurn

handle_direction_request : (
      Model.Type ->
      Battlemap.Direction.Type ->
      Model.Type
   )
handle_direction_request model dir =
   (case (model.selection, model.navigator) of
      (Nothing, _) -> model
      (_ , Nothing) -> model
      ((Just char_id), (Just nav)) ->
         let
            (new_bmap, new_nav) =
               (Battlemap.Navigator.go
                  model.battlemap
                  nav
                  dir
                  (Dict.values model.characters)
               )
         in
            {model |
               battlemap = new_bmap,
               navigator = (Just new_nav)
            }
   )

handle_select_character : Model.Type -> Character.Ref -> Model.Type
handle_select_character model char_id =
   {model |
      selection = (Just char_id),
      battlemap =
         (Battlemap.apply_to_all_tiles
            model.battlemap
            (Battlemap.Navigator.reset_navigation)
         ),
      navigator =
         (case (Dict.get char_id model.characters) of
            Nothing -> Nothing
            (Just char) ->
               (Just
                  (Battlemap.Navigator.new_navigator
                     char.location
                     char.movement_points
                  )
               )
         )
   }

handle_end_turn : Model.Type -> Model.Type
handle_end_turn model =
   case (model.navigator, model.selection) of
      (_, Nothing) -> model
      (Nothing, _) -> model
      ((Just nav), (Just char_id)) ->
         (case (Dict.get char_id model.characters) of
            Nothing -> model
            (Just char) ->
               {model |
                  navigator =
                     (Just
                        (Battlemap.Navigator.new_navigator
                           nav.current_location
                           char.movement_points
                        )
                     ),
                  battlemap =
                     (Battlemap.apply_to_all_tiles
                        (Battlemap.apply_to_tile_unsafe
                           (Battlemap.apply_to_tile_unsafe
                              model.battlemap
                              char.location
                              (\t -> {t | char_level = Nothing})
                           )
                           nav.current_location
                           (\t -> {t | char_level = (Just char_id)})
                        )
                        (Battlemap.Navigator.reset_navigation)
                     ),
                  characters =
                     (Dict.update
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

update : Type -> Model.Type -> Model.Type
update msg model =
   case msg of
      (DirectionRequest d) ->
         (handle_direction_request model d)
      (SelectCharacter char_id) ->
         (handle_select_character model char_id)
      EndTurn ->
         (handle_end_turn model)
      --_ -> model
