module Comm.Send exposing (try_sending, empty_request)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

--- Battle Characters ----------------------------------------------------------
import BattleCharacters.Comm.AddDataSetItem

--- Local Module ---------------------------------------------------------------
import Comm.GoTo
import Comm.AddChar
import Comm.SetInventory

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
      "set_inventory" -> (Comm.SetInventory.decode)

      "add_char" -> (Comm.AddChar.decode)

      "disconnected" -> (Json.Decode.succeed Struct.ServerReply.Disconnected)
      "goto" -> (Comm.GoTo.decode)
      "okay" -> (Json.Decode.succeed Struct.ServerReply.Okay)

      other ->
         if
         (String.startsWith
            (BattleCharacters.Comm.AddDataSetItem.prefix)
            reply_type
         )
         then (BattleCharacters.Comm.AddDataSetItem.get_decoder_for reply_type)
         else
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
try_sending : (
      Struct.Model.Type ->
      String ->
      (Struct.Model.Type -> (Maybe Json.Encode.Value)) ->
      (Maybe (Cmd Struct.Event.Type))
   )
try_sending model recipient try_encoding_fun =
   case (try_encoding_fun model) of
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

empty_request : (
      Struct.Model.Type ->
      String ->
      (Cmd Struct.Event.Type)
   )
empty_request model recipient =
   (Http.get
      {
         url = recipient,
         expect =
            (Http.expectJson
               Struct.Event.ServerReplied
               (Json.Decode.list (decode))
            )
      }
   )
