module Send.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Send.Send

import Struct.Battlemap
import Struct.CharacterTurn
import Struct.Direction
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Struct.Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   case
      (Struct.CharacterTurn.try_getting_controlled_character model.char_turn)
   of
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
                              (Struct.CharacterTurn.get_path model.char_turn)
                           )
                        )
                     )
                  ),
                  (
                     "targets_id",
                     (Json.Encode.list
                        (List.map
                           (Json.Encode.string)
                           (Struct.CharacterTurn.get_targets model.char_turn)
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
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Send.Send.try_sending
      model
      Constants.IO.character_turn_handler
      try_encoding
   )
