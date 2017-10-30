module IO.CharacterTurn exposing (send)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Encode
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Event

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Reply =

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Model -> (Maybe String)
try_encoding model =
   case (Model.get_state model) of
      (Model.ControllingCharacter char_ref) ->
         (Just
            (Json.Encode.encode
               0
               (Json.Encode.object
                  [
                     ("user_token", Json.Encode.string model.user_token),
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
         )

      _ ->
         Nothing

decode : (Json.Decode.Decoder a)
decode =
-- Reply:
-- {
--    TYPES: (list Instr-Type),
--    DATA: (list Instr-Data)
-- }
--
-- Instr-Type : display-message, move-char, etc...
-- Instr-Data : {category: int, content: string}, {char_id: string, x: int, y: int}

receive : (Http.Result (Http.Error a)) -> Event
receive reply =

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try_sending : Model -> (Maybe (Http.Request String))
try_sending model =
   case (try_encoding model) of
      (Just serial) ->
         (Just
            (Http.send
               (receive)
               (Http.post
                  Constants.IO.battlemap_handler_url
                  (Http.jsonBody serial)
                  (decode)
               )
            )
         )

      Nothing -> Nothing
