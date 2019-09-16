module Struct.Character exposing
   (
      Type,
      Unresolved,
      get_index,
      get_battle_index,
      set_battle_index,
      get_base_character,
      set_base_character,
      set_was_edited,
      get_was_edited,
      set_is_valid,
      get_is_valid,
      update_glyph_family_index_collections,
      get_invalid_glyph_family_indices,
      get_all_glyph_family_indices,
      resolve,
      to_unresolved,
      decoder,
      encode
   )

-- Elm -------------------------------------------------------------------------
import Array

import Set

import Json.Decode
import Json.Decode.Pipeline

import Json.Encode

-- Shared ----------------------------------------------------------------------
import Util.List

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Glyph

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      ix : Int,
      battle_ix : Int,
      was_edited : Bool,
      is_valid : Bool,
      invalid_glyph_family_ids : (Set.Set BattleCharacters.Struct.Glyph.Ref),
      all_glyph_family_ids : (Set.Set BattleCharacters.Struct.Glyph.Ref),
      base : BattleCharacters.Struct.Character.Type
   }

type alias Unresolved =
   {
      ix : Int,
      battle_ix : Int,
      was_edited : Bool,
      is_valid : Bool,
      invalid_glyph_family_ids : (Set.Set BattleCharacters.Struct.Glyph.Ref),
      all_glyph_family_ids : (Set.Set BattleCharacters.Struct.Glyph.Ref),
      base : BattleCharacters.Struct.Character.Unresolved
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
compute_glyph_family_id_collections : (
      BattleCharacters.Struct.Equipment.Type ->
      (
         (Set.Set BattleCharacters.Struct.Glyph.Ref),
         (Set.Set BattleCharacters.Struct.Glyph.Ref)
      )
   )
compute_glyph_family_id_collections equipment =
   let
      family_ids_list =
         (List.map
            (BattleCharacters.Struct.Glyph.get_family_id)
            (Array.toList
               (BattleCharacters.Struct.Equipment.get_glyphs equipment)
            )
         )
      no_glyph_family_id =
         (BattleCharacters.Struct.Glyph.get_family_id
            (BattleCharacters.Struct.Glyph.none)
         )
   in
      (
         (Set.remove
            no_glyph_family_id
            (Set.fromList family_ids_list)
         ),
         (Set.remove
            no_glyph_family_id
            (Util.List.duplicates
               family_ids_list
            )
         )
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_index : Type -> Int
get_index c = c.ix

get_battle_index : Type -> Int
get_battle_index c = c.battle_ix

set_battle_index : Int -> Type -> Type
set_battle_index battle_ix c = {c | battle_ix = battle_ix}

get_base_character : Type -> BattleCharacters.Struct.Character.Type
get_base_character c = c.base

set_base_character : BattleCharacters.Struct.Character.Type -> Type -> Type
set_base_character base c = {c | base = base }

get_was_edited : Type -> Bool
get_was_edited char = char.was_edited

set_was_edited : Bool -> Type -> Type
set_was_edited val char = {char | was_edited = val}

get_is_valid : Type -> Bool
get_is_valid char = char.is_valid

set_is_valid : Type -> Type
set_is_valid char =
   let
      s0_base_char = char.base
      s1_base_char =
         if (BattleCharacters.Struct.Character.is_using_secondary s0_base_char)
         then (BattleCharacters.Struct.Character.switch_weapons s0_base_char)
         else s0_base_char
   in
      {char |
         is_valid =
            (
               (Set.isEmpty char.invalid_glyph_family_ids)
               &&
               (List.all
                  (\(s, i) -> (i >= 0))
                  (Battle.Struct.Omnimods.get_all_mods
                     (BattleCharacters.Struct.Character.get_omnimods
                        s1_base_char
                     )
                  )
               )
            )
      }

get_invalid_glyph_family_indices : (
      Type ->
      (Set.Set BattleCharacters.Struct.Glyph.Ref)
   )
get_invalid_glyph_family_indices char = char.invalid_glyph_family_ids

get_all_glyph_family_indices : (
      Type ->
      (Set.Set BattleCharacters.Struct.Glyph.Ref)
   )
get_all_glyph_family_indices char = char.all_glyph_family_ids

update_glyph_family_index_collections : (
      BattleCharacters.Struct.Equipment.Type ->
      Type ->
      Type
   )
update_glyph_family_index_collections equipment char =
   let
      (used_ids, overused_ids) =
         (compute_glyph_family_id_collections equipment)
   in
      (set_is_valid
         {char |
            all_glyph_family_ids = used_ids,
            invalid_glyph_family_ids = overused_ids
         }
      )

resolve : (
      (
         BattleCharacters.Struct.Equipment.Unresolved ->
         BattleCharacters.Struct.Equipment.Type
      ) ->
      Unresolved ->
      Type
   )
resolve equipment_resolver ref =
   let
      base_character =
         (BattleCharacters.Struct.Character.resolve
            (equipment_resolver)
            (Battle.Struct.Omnimods.none)
            ref.base
         )
      (all_glyph_family_ids, invalid_glyph_family_ids) =
         (compute_glyph_family_id_collections
            (BattleCharacters.Struct.Character.get_equipment base_character)
         )
   in
      (set_is_valid
         {
            ix = ref.ix,
            battle_ix = ref.battle_ix,
            was_edited = ref.was_edited,
            is_valid = False,
            invalid_glyph_family_ids = invalid_glyph_family_ids,
            all_glyph_family_ids = all_glyph_family_ids,
            base = base_character
         }
      )

to_unresolved : Type -> Unresolved
to_unresolved char =
   {
      ix = char.ix,
      battle_ix = char.battle_ix,
      was_edited = char.was_edited,
      is_valid = char.is_valid,
      invalid_glyph_family_ids = char.invalid_glyph_family_ids,
      all_glyph_family_ids = char.all_glyph_family_ids,
      base = (BattleCharacters.Struct.Character.to_unresolved char.base)
   }

decoder : (Json.Decode.Decoder Unresolved)
decoder =
   (Json.Decode.succeed
      Unresolved
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.hardcoded -1)
      |> (Json.Decode.Pipeline.hardcoded False)
      |> (Json.Decode.Pipeline.hardcoded True)
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |>
         (Json.Decode.Pipeline.required
            "bas"
            (BattleCharacters.Struct.Character.decoder)
         )
   )

encode : Unresolved -> Json.Encode.Value
encode ref =
   (Json.Encode.object
      [
         ("ix", (Json.Encode.int ref.ix)),
         ("bix", (Json.Encode.int ref.battle_ix)),
         ("bas", (BattleCharacters.Struct.Character.encode ref.base))
      ]
   )
