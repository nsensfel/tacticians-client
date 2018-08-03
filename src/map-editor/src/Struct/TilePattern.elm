module Struct.TilePattern exposing
   (
      Type,
      decoder,
      get_pattern_for,
      patterns_match,
      get_pattern,
      get_variant,
      is_wild
   )

-- Elm -------------------------------------------------------------------------
import List

import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Struct.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      v : Int,
      w : Bool,
      p : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_pattern_for : Int -> (List Struct.Tile.Instance) -> String
get_pattern_for source_fa neighborhood =
   (List.foldl
      (\t -> \acc ->
         let
            t_fa = (Struct.Tile.get_instance_family t)
         in
            if ((t_fa == -1) || (t_fa == source_fa))
            then (acc ++ "1")
            else (acc ++ "0")
      )
      ""
      neighborhood
   )

patterns_match : String -> String -> Bool
patterns_match a b =
   case ((String.uncons a), (String.uncons b)) of
      (Nothing, _) -> True
      ((Just (a_h, a_r)), (Just (b_h, b_r))) ->
         if ((b_h == '2') || (a_h == b_h))
         then (patterns_match a_r b_r)
         else False

      (_, _) -> False

get_pattern : Type -> String
get_pattern tp = tp.p

get_variant : Type -> Int
get_variant tp = tp.v

is_wild : Type -> Bool
is_wild tp = tp.w

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "v" (Json.Decode.int))
      |> (Json.Decode.Pipeline.required "w" (Json.Decode.bool))
      |> (Json.Decode.Pipeline.required "p" (Json.Decode.string))
   )
