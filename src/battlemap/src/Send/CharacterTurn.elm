module Send.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Direction

import UI

import Constants.IO
import Event

import Model

import Send
--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   case (Model.get_state model) of
      (Model.ControllingCharacter char_ref) ->
         (Just
            (Json.Encode.object
               [
                  ("session_token", Json.Encode.string "0"),
                  ("player_id", Json.Encode.string "0"),
                  ("battlemap_id", Json.Encode.string "0"),
                  ("instance_id", Json.Encode.string "0"),
                  ("char_id", Json.Encode.string char_ref),
                  (
                     "path",
                     (Json.Encode.list
                        (List.map
                           (
                              (Json.Encode.string)
                              <<
                              (Battlemap.Direction.to_string)
                           )
                           (Battlemap.get_navigator_path model.battlemap)
                        )
                     )
                  ),
                  (
                     "target_id",
                     (Json.Encode.string
                        (case (UI.get_previous_action model.ui) of
                           (Just (UI.AttackedCharacter id)) -> id
                           _ -> ""
                        )
                     )
                  )
               ]
            )
         )

      _ ->
         Nothing

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Model.Type -> (Maybe (Cmd Event.Type))
try model =
   (Send.try_sending model Constants.IO.character_turn_handler try_encoding)
