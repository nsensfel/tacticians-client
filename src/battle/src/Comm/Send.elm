module Comm.Send exposing (maybe_send)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Comm.AddDataSetItem

-- Battle Map ------------------------------------------------------------------
import BattleMap.Comm.AddDataSetItem
import BattleMap.Comm.SetMap

-- Local Module ----------------------------------------------------------------
import Comm.AddChar
import Comm.AddPlayer
import Comm.SetTimeline
import Comm.TurnResults

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
      "set_map" -> (BattleMap.Comm.SetMap.decode)

      "add_char" -> (Comm.AddChar.decode)
      "add_player" -> (Comm.AddPlayer.decode)
      "set_timeline" -> (Comm.SetTimeline.decode)
      "turn_results" -> (Comm.TurnResults.decode)

      "disconnected" -> (Json.Decode.succeed Struct.ServerReply.Disconnected)
      "okay" -> (Json.Decode.succeed Struct.ServerReply.Okay)

      other ->
         if
         (String.startsWith
            (BattleCharacters.Comm.AddDataSetItem.prefix)
            reply_type
         )
         then (BattleCharacters.Comm.AddDataSetItem.get_decoder_for reply_type)
         else
            if
            (String.startsWith
               (BattleMap.Comm.AddDataSetItem.prefix)
               reply_type
            )
            then (BattleMap.Comm.AddDataSetItem.get_decoder_for reply_type)
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
maybe_send : (
      Struct.Model.Type ->
      String ->
      (Struct.Model.Type -> (Maybe Json.Encode.Value)) ->
      (Maybe (Cmd Struct.Event.Type))
   )
maybe_send model recipient maybe_encode_fun =
   case (maybe_encode_fun model) of
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
