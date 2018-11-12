module Struct.GlyphBoard exposing
   (
      Type,
      Ref,
      get_name,
      get_id,
      get_omnimods,
      get_omnimods_with_glyphs,
      decoder,
      none,
      default
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline

-- Roster Editor ---------------------------------------------------------------
import Struct.Glyph
import Struct.Omnimods

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      slots : (List Int),
      omnimods : Struct.Omnimods.Type
   }

type alias Ref = String

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_id : Type -> String
get_id g = g.id

get_name : Type -> String
get_name g = g.name

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods g = g.omnimods

get_omnimods_with_glyphs : (
      (Array.Array Struct.Glyph.Type) ->
      Type ->
      Struct.Omnimods.Type
   )
get_omnimods_with_glyphs glyphs board = board.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required
            "slot"
            (Json.Decode.list (Json.Decode.int))
         )
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )

none : Type
none =
   {
      id = "",
      name = "None",
      slots = [],
      omnimods = (Struct.Omnimods.none)
   }

default : Type
default = (none)
