module Send.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Send.Send

import Struct.Character
import Struct.CharacterTurn
import Struct.Direction
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Struct.Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   case
      (Struct.CharacterTurn.try_getting_active_character model.char_turn)
   of
      (Just char) ->
         (Just
            (Json.Encode.object
               [
                  ("stk", (Json.Encode.string "0")),
                  ("pid", (Json.Encode.string model.player_id)),
                  ("bmi", (Json.Encode.string "0")),
                  (
                     "cix",
                     (Json.Encode.string (Struct.Character.get_ref char))
                  ),
                  (
                     "p",
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
                     "tix",
                     (Json.Encode.string
                        (
                           case
                              (Struct.CharacterTurn.get_targets model.char_turn)
                           of
                              [a] -> a
                              _ -> "-1"
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
