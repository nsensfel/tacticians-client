module Update.SelectCharacter exposing (apply_to)

import Dict

import Character

import Battlemap
import Battlemap.Navigator

import Model

apply_to : Model.Type -> Character.Ref -> Model.Type
apply_to model char_id =
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
