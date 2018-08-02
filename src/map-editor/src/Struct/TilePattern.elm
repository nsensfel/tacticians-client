module Struct.TilePattern exposing
   (
      PatternElement(..),
      Type,
      decoder,
      matches,
      matches_pattern,
      get_source_pattern,
      get_target
   )

-- Elm -------------------------------------------------------------------------
import List

import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Constants.UI
import Constants.Movement

import Struct.Location

import Util.List

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type PatternElement =
   Any
   | Exactly Int
   | Not Int

type alias Type =
   {
      s : PatternElement,
      t : (Int, Int, Int),
      p : (List PatternElement)
   }

type alias PartialPatternElement =
   {
      c : String,
      i : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

matches_internals : (List Int) -> (List PatternElement) -> Bool
matches_internals neighbors pattern =
   case ((Util.List.pop neighbors), (Util.List.pop pattern)) of
      (Nothing, Nothing) -> True
      ((Just (n, r_n)), (Just (p, r_p))) ->
         ((matches_pattern n p) && (matches_internals r_n r_p))

      (_, _) -> False

finish_decoding_pattern : PartialPatternElement -> PatternElement
finish_decoding_pattern ppe =
   case ppe.c of
      "a" -> Any
      "n" -> (Not ppe.i)
      _ -> (Exactly ppe.i)

finish_decoding_target : (List Int) -> (Int, Int, Int)
finish_decoding_target t =
   case t of
      [m] -> (m, m, 0)
      [m, b, v] -> (m, b, v)
      _ -> (0, 0, 0)

pattern_decoder : (Json.Decode.Decoder PatternElement)
pattern_decoder =
   (Json.Decode.map
      (finish_decoding_pattern)
      (Json.Decode.Pipeline.decode
         PartialPatternElement
         |> (Json.Decode.Pipeline.required "c" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "i" Json.Decode.int)
      )
   )

target_decoder : (Json.Decode.Decoder (Int, Int, Int))
target_decoder =
   (Json.Decode.map
      (finish_decoding_target)
      (Json.Decode.list (Json.Decode.int))
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
matches_pattern : Int -> PatternElement -> Bool
matches_pattern n p =
   case p of
      (Exactly v) -> (v == n)
      (Not v) -> (v /= n)
      Any -> True

matches : (List Int) -> Int -> Type -> Bool
matches neighbors source tile_pattern =
   (
      (matches_pattern source tile_pattern.s)
      && (matches_internals neighbors tile_pattern.p)
   )

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "s" (pattern_decoder))
      |> (Json.Decode.Pipeline.required "t" (target_decoder))
      |> (Json.Decode.Pipeline.required
            "p"
            (Json.Decode.list (pattern_decoder))
         )
   )

get_target : Type -> (Int, Int, Int)
get_target tile_pattern = tile_pattern.t

get_source_pattern : Type -> PatternElement
get_source_pattern tile_pattern = tile_pattern.s
