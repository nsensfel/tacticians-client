module Send.CharacterTurn exposing (try_sending)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Encode
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Battlemap
import Battlemap.Direction

import UI

import Model

import Send

import Event

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
--            (Json.Encode.encode
--               0
               (Json.Encode.object
                  [
                 --  ("user_token", Json.Encode.string model.user_token),
                     ("user_token", Json.Encode.string "user0"),
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
--            )
         )

      _ ->
         Nothing

decode : (Json.Decode.Decoder String) --Send.Reply)
decode =
   (Json.Decode.string ---Send.Reply
--      |> Json.Decode.required "types" (Json.Decode.list (Json.Decode.string))
--      |> Json.Decode.required "data" (Json.Decode.list (Json.Decode.string))
   )

-- Reply:
-- {
--    TYPES: (list Instr-Type),
--    DATA: (list Instr-Data)
-- }
--
-- Instr-Type : display-message, move-char, etc...
-- Instr-Data : {category: int, content: string}, {char_id: string, x: int, y: int}

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try_sending : Model.Type -> (Maybe (Cmd Event.Type))
try_sending model =
   case (try_encoding model) of
      (Just serial) ->
         (Just
            (Http.send
               Event.ServerReplied
               (Http.post
                  Constants.IO.battlemap_handler_url
                  (Http.jsonBody serial)
                  (decode)
               )
            )
         )

      Nothing -> Nothing
