module Comm.Send exposing (maybe_send)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

-- Map -------------------------------------------------------------------
import Comm.Okay
import Comm.SetPlayer

import Struct.Event
import Struct.ServerReply
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : String -> (Json.Decode.Decoder Struct.ServerReply.Type)
internal_decoder reply_type =
   case reply_type of
      "okay" -> (Comm.Okay.decode)
      "set_plr" -> (Comm.SetPlayer.decode)
      "disconnected" -> (Json.Decode.succeed Struct.ServerReply.Disconnected)
      other ->
         (Json.Decode.fail
            (
               "Unknown server command \""
               ++ other
               ++ "\""
            )
         )

decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.field "msg" Json.Decode.string)
   |> (Json.Decode.andThen (internal_decoder))

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_send : (
      Struct.Model.Type ->
      String ->
      (Struct.Model.Type -> (Maybe Json.Encode.Value)) ->
      (Maybe (Cmd Struct.Event.Type))
   )
maybe_send model recipient maybe_encod_fun =
   case (maybe_encod_fun model) of
      (Just serial) ->
         (Just
            (Http.post
               {
                  url = recipient,
                  body = (Http.jsonBody serial),
                  expect =
                     (Http.expectJson
                        Struct.Event.ServerReplied
                        (Json.Decode.list (decode))
                     )
               }
            )
         )

      Nothing -> Nothing
