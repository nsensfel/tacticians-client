module Send.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Direction
import Struct.UI
import Struct.Event
import Struct.Model

import Constants.IO

import Send

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Struct.Model.Type -> (Maybe Json.Encode.Value)
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
                              (Struct.Direction.to_string)
                           )
                           (List.reverse
                              (Struct.Battlemap.get_navigator_path model.battlemap)
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
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Send.try_sending model Constants.IO.character_turn_handler try_encoding)
