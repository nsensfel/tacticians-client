module Update.EndTurn exposing (apply_to)

import Dict

import Battlemap
import Battlemap.Direction
import Battlemap.Navigator
import Battlemap.Tile

import Model

update_model : Model.Type -> Battlemap.Navigator.Type -> String -> Model.Type
update_model model nav char_id =
   case (Dict.get char_id model.characters) of
      Nothing -> model
      (Just char) ->
         {model |
            navigator = Nothing,
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
                  (Battlemap.Tile.set_navigation Battlemap.Direction.None)
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

apply_to : Model.Type -> Model.Type
apply_to model =
   case (model.navigator, model.selection) of
      (_, Nothing) -> model
      (Nothing, _) -> model
      ((Just nav), (Just char_id)) -> (update_model model nav char_id)
