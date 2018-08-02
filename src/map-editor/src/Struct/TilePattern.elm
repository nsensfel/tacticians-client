module Struct.TilePattern exposing
   (
      PatternElement(..),
      Type,
      decoder,
      matches,
      matches_pattern
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
   | Major
   | Minor

type alias Type =
   {
      t : (PatternElement, PatternElement),
      tv : Int,
      p : (List PatternElement)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
matches_internals : (
      Int ->
      (List Int) ->
      (List PatternElement) ->
      (Maybe Int) ->
      (Bool, Int)
   )
matches_internals source neighbors pattern maybe_border =
   case ((Util.List.pop neighbors), (Util.List.pop pattern)) of
      (Nothing, Nothing) ->
         (
            True,
            (
               case maybe_border of
                  Nothing -> source
                  (Just e) -> e
            )
         )

      ((Just (n, r_n)), (Just (p, r_p))) ->
         if (matches_pattern source n p)
         then
            if
            (
               (maybe_border == (Just source))
               || (maybe_border == Nothing)
            )
            then
               (matches_internals source r_n r_p (Just n))
            else
               (matches_internals source r_n r_p maybe_border)
         else
            (False, source)

      (_, _) -> (False, source)

finish_decoding_pattern : String -> PatternElement
finish_decoding_pattern str =
   case str of
      "any" -> Any
      "A" -> Minor
      "B" -> Major
      _ -> Major

finish_decoding_target : (
      (List String) ->
      (PatternElement, PatternElement)
   )
finish_decoding_target t =
   case t of
      ["A", "B"] -> (Minor, Major)
      ["A", "A"] -> (Minor, Minor)
      ["B", "A"] -> (Major, Minor)
      ["B", "B"] -> (Major, Major)
      _ -> (Minor, Minor)

pattern_decoder : (Json.Decode.Decoder PatternElement)
pattern_decoder =
   (Json.Decode.map
      (finish_decoding_pattern)
      (Json.Decode.string)
   )

target_decoder : (
      (Json.Decode.Decoder (PatternElement, PatternElement))
   )
target_decoder =
   (Json.Decode.map
      (finish_decoding_target)
      (Json.Decode.list (Json.Decode.string))
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
matches_pattern : Int -> Int -> PatternElement -> Bool
matches_pattern source n p =
   case p of
      Any -> True
      Major -> (source < n)
      Minor -> (source >= n)

matches : (List Int) -> Int -> Type -> (Bool, Int, Int, Int)
matches neighbors source tile_pattern =
   case (matches_internals source neighbors tile_pattern.p Nothing) of
      (False, _) -> (False, 0, 0, 0)
      (True, border) ->
         case tile_pattern.t of
            (Minor, Major) -> (True, source, border, tile_pattern.tv)
            (Minor, Minor) -> (True, source, source, tile_pattern.tv)
            (Major, Minor) -> (True, border, source, tile_pattern.tv)
            (_, _) -> (True, border, border, tile_pattern.tv)

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "t" (target_decoder))
      |> (Json.Decode.Pipeline.required "tv" (Json.Decode.int))
      |> (Json.Decode.Pipeline.required
            "p"
            (Json.Decode.list (pattern_decoder))
         )
   )
