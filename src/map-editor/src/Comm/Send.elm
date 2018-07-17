module Comm.Send exposing (try_sending, empty_request)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Comm.AddTile
import Comm.AddTilePattern
import Comm.Okay
import Comm.SetMap

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
      "add_tile_pattern" -> (Comm.AddTilePattern.decode)
      "set_map" -> (Comm.SetMap.decode)
      "okay" -> (Comm.Okay.decode)
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

empty_request : (
      Struct.Model.Type ->
      String ->
      (Cmd Struct.Event.Type)
   )
empty_request model recipient =
   (Http.send
      Struct.Event.ServerReplied
      (Http.get
         recipient
         (Json.Decode.list (decode))
      )
   )
