module Comm.Send exposing (try_sending)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Comm.AddArmor
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
      "add_weapon" -> (Comm.AddWeapon.decode)
      "set_map" -> (Comm.SetMap.decode)
      "turn_results" -> (Comm.TurnResults.decode)
      "set_timeline" -> (Comm.SetTimeline.decode)
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
            (Http.send
               Struct.Event.ServerReplied
               (Http.post
                  recipient
                  (Http.jsonBody serial)
                  (Json.Decode.list (decode))
               )
            )
         )

      Nothing -> Nothing
