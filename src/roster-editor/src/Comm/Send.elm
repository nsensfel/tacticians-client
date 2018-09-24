module Comm.Send exposing (try_sending)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

--- Roster Editor --------------------------------------------------------------
import Comm.AddArmor
import Comm.AddChar
import Comm.AddWeapon
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
      "add_armor" -> (Comm.AddArmor.decode)
      "add_char" -> (Comm.AddChar.decode)
      "add_weapon" -> (Comm.AddWeapon.decode)
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
