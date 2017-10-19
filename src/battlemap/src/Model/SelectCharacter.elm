module Model.SelectCharacter exposing (apply_to)

import Dict

import Character

import Battlemap

import Model
import Error

make_it_so : Model.Type -> Character.Ref -> Model.Type
make_it_so model char_id =
   case (Dict.get char_id model.characters) of
      (Just char) ->
            {model |
               state = Model.MovingCharacterWithClick,
               selection = (Model.SelectedCharacter char_id),
               battlemap =
                  (Battlemap.set_navigator
                     (Character.get_location char)
                     (Character.get_movement_points char)
                     (Character.get_attack_range char)
                     (\loc ->
                        (loc == (Character.get_location char))
                        ||
                        (List.all
                           (\c -> ((Character.get_location c) /= loc))
                           (Dict.values model.characters)
                        )
                     )
                     model.battlemap
                  )
            }

      Nothing ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "SelectCharacter: Unknown char selected."
            )
         )

apply_to : Model.Type -> Character.Ref -> Model.Type
apply_to model char_id =
   case (Model.get_state model) of
      _ -> (make_it_so model char_id)
