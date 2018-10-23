module Struct.Inventory exposing
   (
      Type,
      has_portrait,
      has_glyph,
      has_glyph_board,
      has_weapon,
      has_armor,
      empty,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

import Set

-- Battle ----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      portraits : (Set.Set Int),
      glyphs : (Set.Set Int),
      glyph_boards : (Set.Set Int),
      weapons : (Set.Set Int),
      armors : (Set.Set Int)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
has_portrait : Int -> Type -> Bool
has_portrait id inv = (Set.member id inv.portraits)

has_glyph : Int -> Type -> Bool
has_glyph id inv = (Set.member id inv.glyphs)

has_glyph_board : Int -> Type -> Bool
has_glyph_board id inv = (Set.member id inv.glyph_boards)

has_weapon : Int -> Type -> Bool
has_weapon id inv = (Set.member id inv.weapons)

has_armor : Int -> Type -> Bool
has_armor id inv = (Set.member id inv.armors)

empty : Type
empty =
   {
      portraits = (Set.empty),
      glyphs = (Set.empty),
      glyph_boards = (Set.empty),
      weapons = (Set.empty),
      armors = (Set.empty)
   }

decoder : (Json.Decode.Decoder Type)
decoder =
   -- TODO
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
   )
