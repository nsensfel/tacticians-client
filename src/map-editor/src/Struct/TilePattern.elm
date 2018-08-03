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
import Struct.Tile

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
      Struct.Tile.Instance ->
      (List Struct.Tile.Instance) ->
      (List PatternElement) ->
      (Maybe Int) ->
      (Maybe Int) ->
      (Bool, Int)
   )
matches_internals source neighbors pattern maybe_border_fa maybe_border_mc =
   case ((Util.List.pop neighbors), (Util.List.pop pattern)) of
      (Nothing, Nothing) ->
         (
            True,
            (
               case maybe_border_mc of
                  Nothing -> (Struct.Tile.get_type_id source)
                  (Just e) -> e
            )
         )

      ((Just (n, r_n)), (Just (p, r_p))) ->
         if (matches_pattern source n p)
         then
            let
               source_mc = (Struct.Tile.get_type_id source)
               source_fa = (Struct.Tile.get_instance_family source)
               n_mc = (Struct.Tile.get_type_id n)
               n_fa = (Struct.Tile.get_instance_family n)
            in
               if
               (
                  (maybe_border_fa == (Just source_fa))
                  || (maybe_border_fa == Nothing)
                  || (maybe_border_fa == (Just n_fa))
                  || (maybe_border_fa == (Just -1))
               )
               then
                  (matches_internals
                     source
                     r_n
                     r_p
                     (Just n_fa)
                     (Just n_mc)
                  )
               else
                  if ((n_fa == -1) || (n_fa == source_fa))
                  then
                     (matches_internals
                        source
                        r_n
                        r_p
                        maybe_border_fa
                        maybe_border_mc
                     )
                  else (False, source_mc)
         else
            (False, (Struct.Tile.get_type_id source))

      (_, _) -> (False, (Struct.Tile.get_type_id source))

finish_decoding_pattern : String -> PatternElement
finish_decoding_pattern str =
   case str of
      "any" -> Any
      "A" -> Minor
      "B" -> Major
      _ -> Minor

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
matches_pattern : (
      Struct.Tile.Instance ->
      Struct.Tile.Instance ->
      PatternElement ->
      Bool
   )
matches_pattern source n p =
   let
      source_fa = (Struct.Tile.get_instance_family source)
      n_fa = (Struct.Tile.get_instance_family n)
   in
   case p of
      Any -> True
      Major -> (source_fa < n_fa)
      Minor -> ((source_fa == n_fa) || (n_fa == -1))

matches : (
      (List Struct.Tile.Instance) ->
      Struct.Tile.Instance ->
      Type ->
      (Bool, Int, Int, Int)
   )
matches neighbors source tile_pattern =
   case (matches_internals source neighbors tile_pattern.p Nothing Nothing) of
      (False, _) -> (False, 0, 0, 0)
      (True, border_mc) ->
         let
            source_mc = (Struct.Tile.get_type_id source)
         in
            case tile_pattern.t of
               (Minor, Major) -> (True, source_mc, border_mc, tile_pattern.tv)
               (Minor, Minor) -> (True, source_mc, source_mc, tile_pattern.tv)
               (Major, Minor) -> (True, border_mc, source_mc, tile_pattern.tv)
               (_, _) -> (True, border_mc, border_mc, tile_pattern.tv)

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
