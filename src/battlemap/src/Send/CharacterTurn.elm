module Send.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
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
   case model.controlled_character of
      (Just char_ref) ->
         (Just
            (Json.Encode.object
               [
                  ("session_token", (Json.Encode.string "0")),
                  ("player_id", (Json.Encode.string model.player_id)),
                  ("battlemap_id", (Json.Encode.string "0")),
                  ("instance_id", (Json.Encode.string "0")),
                  ("char_id", (Json.Encode.string char_ref)),
                  (
                     "path",
                     (Json.Encode.list
                        (List.map
                           (
                              (Json.Encode.string)
                              <<
                              (Battlemap.Direction.to_string)
                           )
                           (List.reverse
                              (Battlemap.get_navigator_path model.battlemap)
                           )
                        )
                     )
                  ),
                  (
                     "targets_id",
                     (Json.Encode.list
                        (List.map (Json.Encode.string) model.targets)
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
