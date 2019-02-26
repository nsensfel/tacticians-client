module Struct.TilePattern exposing
   (
      Type,
      Actual,
      decoder,
      get_pattern_for,
      patterns_match,
      get_pattern,
      get_variant_id,
      is_wild
   )

-- Elm -------------------------------------------------------------------------
import List

import Json.Decode
import Json.Decode.Pipeline

-- Map Editor ------------------------------------------------------------------
import Struct.Tile
import Struct.TileInstance

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Actual = String

type alias Type =
   {
      v : Struct.Tile.VariantID,
      w : Bool,
      p : Actual
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_pattern_for : (
      Struct.Tile.FamilyID ->
      (List Struct.TileInstance.Type) ->
      Actual
   )
get_pattern_for source_fa neighborhood =
   (List.foldl
      (\t -> \acc ->
         let
            t_fa = (Struct.TileInstance.get_family t)
         in
            if ((t_fa == "-1") || (t_fa == source_fa))
            then (acc ++ "1")
            else (acc ++ "0")
      )
      ""
      neighborhood
   )

patterns_match : Actual -> Actual -> Bool
patterns_match a b =
   case ((String.uncons a), (String.uncons b)) of
      (Nothing, _) -> True
      ((Just (a_h, a_r)), (Just (b_h, b_r))) ->
         if ((b_h == '2') || (a_h == b_h))
         then (patterns_match a_r b_r)
         else False

      (_, _) -> False

get_pattern : Type -> Actual
get_pattern tp = tp.p

get_variant_id : Type -> Struct.Tile.VariantID
get_variant_id tp = tp.v

is_wild : Type -> Bool
is_wild tp = tp.w

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "v" (Json.Decode.string))
      |> (Json.Decode.Pipeline.required "w" (Json.Decode.bool))
      |> (Json.Decode.Pipeline.required "p" (Json.Decode.string))
   )
