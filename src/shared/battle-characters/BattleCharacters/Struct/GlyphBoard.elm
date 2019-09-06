module BattleCharacters.Struct.GlyphBoard exposing
   (
      Type,
      Ref,
      find,
      get_name,
      get_id,
      get_slots,
      get_omnimods_with_glyphs,
      decoder,
      none,
      default
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import List

import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Glyph

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      slots : (List Int)
   }

type alias Ref = String

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
find : (Dict.Dict Ref Type) -> Ref -> Type
find dict ref =
   case (Dict.get ref dict) of
      (Just e) -> e
      Nothing -> none

get_id : Type -> String
get_id g = g.id

get_name : Type -> String
get_name g = g.name

get_slots : Type -> (List Int)
get_slots  g = g.slots

get_omnimods_with_glyphs : (
      (Array.Array BattleCharacters.Struct.Glyph.Type) ->
      Type ->
      Battle.Struct.Omnimods.Type
   )
get_omnimods_with_glyphs glyphs board =
   (List.foldl
      (Battle.Struct.Omnimods.merge)
      (Battle.Struct.Omnimods.none)
      (List.map2
         (Battle.Struct.Omnimods.scale)
         (List.map (\e -> ((toFloat e) / 100.0)) board.slots)
         (List.map
            (BattleCharacters.Struct.Glyph.get_omnimods) (Array.toList glyphs)
         )
      )
   )

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required
            "slot"
            (Json.Decode.list (Json.Decode.int))
         )
   )

none : Type
none =
   {
      id = "",
      name = "None",
      slots = []
   }

default : Type
default = (none)
