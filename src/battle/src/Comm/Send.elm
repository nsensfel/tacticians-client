module Comm.Send exposing (try_sending)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Decode
import Json.Encode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Comm.AddArmor
import BattleCharacters.Comm.AddGlyph
import BattleCharacters.Comm.AddGlyphBoard
import BattleCharacters.Comm.AddPortrait
import BattleCharacters.Comm.AddWeapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Comm.AddTile
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
      "add_tile" -> (BattleMap.Comm.AddTile.decode)
      "add_armor" -> (BattleCharacters.Comm.AddArmor.decode)
      "add_char" -> (Comm.AddChar.decode)
      "add_portrait" -> (BattleCharacters.Comm.AddPortrait.decode)
      "add_glyph_board" -> (BattleCharacters.Comm.AddGlyphBoard.decode)
      "add_glyph" -> (BattleCharacters.Comm.AddGlyph.decode)
      "add_player" -> (Comm.AddPlayer.decode)
      "add_weapon" -> (BattleCharacters.Comm.AddWeapon.decode)
      "set_map" -> (BattleMap.Comm.SetMap.decode)
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
