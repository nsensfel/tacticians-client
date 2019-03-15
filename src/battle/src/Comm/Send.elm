module Comm.Send exposing (try_sending)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

-- Local Module ----------------------------------------------------------------
import Comm.AddArmor
import Comm.AddPortrait
import Comm.AddPlayer
import Comm.AddChar
import Comm.AddTile
import Comm.AddWeapon
import Comm.SetMap
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
      "add_tile" -> (Comm.AddTile.decode)
      "add_armor" -> (Comm.AddArmor.decode)
      "add_char" -> (Comm.AddChar.decode)
      "add_portrait" -> (Comm.AddPortrait.decode)
      "add_player" -> (Comm.AddPlayer.decode)
      "add_weapon" -> (Comm.AddWeapon.decode)
      "set_map" -> (Comm.SetMap.decode)
      "turn_results" -> (Comm.TurnResults.decode)
      "set_timeline" -> (Comm.SetTimeline.decode)
      "disconnected" -> (Json.Decode.succeed Struct.ServerReply.Disconnected)
      "okay" -> (Json.Decode.succeed Struct.ServerReply.Okay)

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
