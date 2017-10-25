module Model.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Character

import Battlemap

import Model
import Error

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : Model.Type -> Character.Ref -> Model.Type
make_it_so model char_id =
   case (Dict.get char_id model.characters) of
      (Just char) ->
         if ((Character.get_team char) == model.controlled_team)
         then
            {model |
               state = (Model.ControllingCharacter char_id),
               battlemap =
                  (Battlemap.set_navigator
                     (Character.get_location char)
                     (Character.get_movement_points char)
                     (Character.get_attack_range char)
                     (Dict.values model.characters)
                     model.battlemap
                  )
            }
         else
            (Model.invalidate
               model
               (Error.new
                  Error.IllegalAction
                  "SelectCharacter: Wrong team. Attack is not implemented."
               )
            )

      Nothing ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "SelectCharacter: Unknown char selected."
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> Character.Ref -> Model.Type
apply_to model char_id =
   case (Model.get_state model) of
      _ -> (make_it_so model char_id)
