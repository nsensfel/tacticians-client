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
      resolve,
      to_unresolved,
      decoder,
      encode
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

import Json.Encode

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      ix : Int,
      battle_ix : Int,
      was_edited : Bool,
      is_valid : Bool,
      base : BattleCharacters.Struct.Character.Type
   }

type alias Unresolved =
   {
      ix : Int,
      battle_ix : Int,
      was_edited : Bool,
      is_valid : Bool,
      base : BattleCharacters.Struct.Character.Unresolved
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

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
   {char |
      is_valid =
         (
            (List.all
               (\(s, i) -> (i >= 0))
               (Battle.Struct.Omnimods.get_all_mods
                  (BattleCharacters.Struct.Character.get_omnimods char.base)
               )
            )
            &&
            (
               (Battle.Struct.Attributes.get_max_health
                  (BattleCharacters.Struct.Character.get_attributes char.base)
               )
               > 0
            )
         )
   }

resolve : (
      (
         BattleCharacters.Struct.Equipment.Unresolved ->
         BattleCharacters.Struct.Equipment.Type
      ) ->
      Unresolved ->
      Type
   )
resolve equipment_resolver ref =
   (set_is_valid
      {
         ix = ref.ix,
         battle_ix = ref.battle_ix,
         was_edited = ref.was_edited,
         is_valid = False,
         base =
            (BattleCharacters.Struct.Character.resolve
               (equipment_resolver)
               (Battle.Struct.Omnimods.none)
               ref.base
            )
      }
   )

to_unresolved : Type -> Unresolved
to_unresolved char =
   {
      ix = char.ix,
      battle_ix = char.battle_ix,
      was_edited = char.was_edited,
      is_valid = char.is_valid,
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
