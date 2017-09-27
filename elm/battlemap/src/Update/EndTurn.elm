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
      Nothing -> {model | state = (Model.Error Error.Programming)}
      (Just selection) ->
         case (Dict.get selection.character model.characters) of
            Nothing -> {model | state = (Model.Error Error.Programming)}
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
   case model.state of
      Model.MovingCharacterWithButtons -> (make_it_so model)
      Model.MovingCharacterWithClick -> (make_it_so model)
      _ -> {model | state = (Model.Error Error.IllegalAction)}

