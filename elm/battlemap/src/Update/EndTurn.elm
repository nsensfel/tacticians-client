module Update.EndTurn exposing (apply_to)

import Dict

import Battlemap
import Battlemap.Direction
import Battlemap.Navigator
import Battlemap.Tile

import Model

import Error

make_it_so : Model.Type -> Model.Type
make_it_so model =
   case model.selection of
      Nothing ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "EndTurn: model moving char, no selection."
            )
         )
      (Just selection) ->
         case (Dict.get selection.character model.characters) of
            Nothing ->
               (Model.invalidate
                  model
                  (Error.new
                     Error.Programming
                     "EndTurn: model moving char, unknown char selected."
                  )
               )
            (Just char) ->
               {model |
                  state = Model.Default,
                  selection = Nothing,
                  battlemap =
                     (Battlemap.apply_to_all_tiles
                        (Battlemap.apply_to_tile_unsafe
                           (Battlemap.apply_to_tile_unsafe
                              model.battlemap
                              char.location
                              (\t -> {t | char_level = Nothing})
                           )
                           selection.navigator.current_location
                           (\t -> {t | char_level = (Just selection.character)})
                        )
                        (Battlemap.Tile.reset)
                     ),
                  characters =
                     (Dict.update
                        selection.character
                        (\mc ->
                           case mc of
                              Nothing -> Nothing
                              (Just c) ->
                                 (Just
                                    {c |
                                       location = selection.navigator.current_location
                                    }
                                 )
                        )
                        model.characters
                     )
               }

apply_to : Model.Type -> Model.Type
apply_to model =
   case (Model.get_state model) of
      Model.MovingCharacterWithButtons -> (make_it_so model)
      Model.MovingCharacterWithClick -> (make_it_so model)
      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.IllegalAction
               "This can only be done while moving a character."
            )
         )
