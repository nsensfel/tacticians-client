module Struct.Character exposing
   (
      Type,
      Rank(..),
      TypeAndEquipmentRef,
      get_index,
      get_player_ix,
      get_name,
      get_rank,
      get_portrait,
      get_armor,
      get_current_health,
      get_current_omnimods,
      get_sane_current_health,
      set_current_health,
      get_location,
      set_location,
      get_attributes,
      get_statistics,
      is_enabled,
      is_defeated,
      is_alive,
      set_enabled,
      set_defeated,
      get_primary_weapon,
      get_secondary_weapon,
      toggle_is_using_primary,
      get_is_using_primary,
      decoder,
      refresh_omnimods,
      fill_missing_equipment_and_omnimods
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.Omnimods
import Battle.Struct.Statistics

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias PartiallyDecoded =
   {
      ix : Int,
      nam : String,
      rnk : String,
      prt : String,
      lc : BattleMap.Struct.Location.Type,
      hea : Int,
      pla : Int,
      ena : Bool,
      dea : Bool,
      awp : BattleCharacters.Struct.Weapon.Ref,
      swp : BattleCharacters.Struct.Weapon.Ref,
      ar : BattleCharacters.Struct.Armor.Ref,
      omni : Battle.Struct.Omnimods.Type
   }


type Rank =
   Optional
   | Target
   | Commander

type alias Type =
   {
      ix : Int,
      name : String,
      rank : Rank,
      portrait : BattleCharacters.Struct.Portrait.Type,
      location : BattleMap.Struct.Location.Type,
      health : Int,
      player_ix : Int,
      enabled : Bool,
      defeated : Bool,
      attributes : Battle.Struct.Attributes.Type,
      statistics : Battle.Struct.Statistics.Type,
      primary_weapon : BattleCharacters.Struct.Weapon.Type,
      secondary_weapon : BattleCharacters.Struct.Weapon.Type,
      is_using_primary : Bool,
      armor : BattleCharacters.Struct.Armor.Type,
      current_omnimods : Battle.Struct.Omnimods.Type,
      permanent_omnimods : Battle.Struct.Omnimods.Type
   }

type alias TypeAndEquipmentRef =
   {
      char : Type,
      main_weapon_ref : String,
      secondary_weapon_ref : String,
      armor_ref : String,
      portrait_ref : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
str_to_rank : String -> Rank
str_to_rank str =
   case str of
      "t" -> Target
      "c" -> Commander
      _ -> Optional

finish_decoding : PartiallyDecoded -> TypeAndEquipmentRef
finish_decoding add_char =
   let
      armor = BattleCharacters.Struct.Armor.none
      portrait = BattleCharacters.Struct.Portrait.default
      default_attributes = (Battle.Struct.Attributes.default)
      almost_char =
         {
            ix = add_char.ix,
            name = add_char.nam,
            rank = (str_to_rank add_char.rnk),
            portrait = portrait,
            location = add_char.lc,
            health = add_char.hea,
            attributes = default_attributes,
            statistics = (Battle.Struct.Statistics.new_raw default_attributes),
            player_ix = add_char.pla,
            enabled = add_char.ena,
            defeated = add_char.dea,
            primary_weapon = BattleCharacters.Struct.Weapon.none,
            secondary_weapon = BattleCharacters.Struct.Weapon.none,
            is_using_primary = True,
            armor = armor,
            current_omnimods = (Battle.Struct.Omnimods.new [] [] [] []),
            permanent_omnimods = add_char.omni
         }
   in
      {
         char = almost_char,
         main_weapon_ref = add_char.awp,
         secondary_weapon_ref = add_char.swp,
         armor_ref = add_char.ar,
         portrait_ref = add_char.prt
      }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_index : Type -> Int
get_index c = c.ix

get_name : Type -> String
get_name c = c.name

get_rank : Type -> Rank
get_rank c = c.rank

get_player_ix : Type -> Int
get_player_ix c = c.player_ix

get_current_health : Type -> Int
get_current_health c = c.health

get_current_omnimods : Type -> Battle.Struct.Omnimods.Type
get_current_omnimods c = c.current_omnimods

get_sane_current_health : Type -> Int
get_sane_current_health c = (max 0 c.health)

set_current_health : Int -> Type -> Type
set_current_health health c = {c | health = health}

get_location : Type -> BattleMap.Struct.Location.Type
get_location t = t.location

set_location : BattleMap.Struct.Location.Type -> Type -> Type
set_location location char = {char | location = location}

get_attributes : Type -> Battle.Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Battle.Struct.Statistics.Type
get_statistics char = char.statistics

is_alive : Type -> Bool
is_alive char = ((char.health > 0) && (not char.defeated))

is_enabled : Type -> Bool
is_enabled char = char.enabled

is_defeated : Type -> Bool
is_defeated char = char.defeated

set_enabled : Bool -> Type -> Type
set_enabled enabled char = {char | enabled = enabled}

set_defeated : Bool -> Type -> Type
set_defeated defeated char = {char | defeated = defeated}

get_primary_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_primary_weapon char = char.primary_weapon

get_secondary_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_secondary_weapon char = char.secondary_weapon

get_is_using_primary : Type -> Bool
get_is_using_primary char = char.is_using_primary

toggle_is_using_primary : Type -> Type
toggle_is_using_primary char =
   {char | is_using_primary = (not char.is_using_primary)}

get_armor : Type -> BattleCharacters.Struct.Armor.Type
get_armor char = char.armor

get_portrait : Type -> BattleCharacters.Struct.Portrait.Type
get_portrait char = char.portrait

decoder : (Json.Decode.Decoder TypeAndEquipmentRef)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.succeed
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "rnk" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "prt" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "lc" BattleMap.Struct.Location.decoder)
         |> (Json.Decode.Pipeline.required "hea" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "pla" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "ena" Json.Decode.bool)
         |> (Json.Decode.Pipeline.required "dea" Json.Decode.bool)
         |> (Json.Decode.Pipeline.required "awp" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "swp" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "ar" Json.Decode.string)
         |>
         (Json.Decode.Pipeline.required
            "pomni"
            Battle.Struct.Omnimods.decoder
         )
      )
   )

refresh_omnimods : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      Type ->
      Type
   )
refresh_omnimods tile_omnimods_fun char =
   let
      previous_max_health =
         (Battle.Struct.Statistics.get_max_health char.statistics)
      current_omnimods =
         (Battle.Struct.Omnimods.merge
            (BattleCharacters.Struct.Weapon.get_omnimods
               (
                  if (char.is_using_primary)
                  then char.primary_weapon
                  else char.secondary_weapon
               )
            )
            (Battle.Struct.Omnimods.merge
               (tile_omnimods_fun char.location)
               char.permanent_omnimods
            )
         )
      current_attributes =
         (Battle.Struct.Omnimods.apply_to_attributes
            current_omnimods
            (Battle.Struct.Attributes.default)
         )
      current_statistics =
         (Battle.Struct.Omnimods.apply_to_statistics
            current_omnimods
            (Battle.Struct.Statistics.new_raw current_attributes)
         )
      new_max_health =
         (Battle.Struct.Statistics.get_max_health current_statistics)
   in
      {char |
         attributes = current_attributes,
         statistics = current_statistics,
         current_omnimods = current_omnimods,
         health =
            (clamp
               1
               new_max_health
               (round
                  (
                     ((toFloat char.health) / (toFloat previous_max_health))
                     * (toFloat new_max_health)
                  )
               )
            )
      }

fill_missing_equipment_and_omnimods : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      BattleCharacters.Struct.Portrait.Type ->
      BattleCharacters.Struct.Weapon.Type ->
      BattleCharacters.Struct.Weapon.Type ->
      BattleCharacters.Struct.Armor.Type ->
      Type ->
      Type
   )
fill_missing_equipment_and_omnimods tile_omnimods_fun pt awp swp ar char =
   (set_current_health
      -- We just changed the omnimods, but already had the right health value
      char.health
      (refresh_omnimods
         (tile_omnimods_fun)
         {char |
            primary_weapon = awp,
            secondary_weapon = swp,
            armor = ar,
            portrait = pt
         }
      )
   )
