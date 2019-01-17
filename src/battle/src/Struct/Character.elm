module Struct.Character exposing
   (
      Type,
      Rank(..),
      TypeAndEquipmentRef,
      get_index,
      get_player_ix,
      get_name,
      get_rank,
      get_icon_id,
      get_portrait_id,
      get_armor,
      get_armor_variation,
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
      get_weapons,
      set_weapons,
      decoder,
      refresh_omnimods,
      fill_missing_equipment_and_omnimods
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Map -------------------------------------------------------------------
import Struct.Armor
import Struct.Attributes
import Struct.Location
import Struct.Omnimods
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias PartiallyDecoded =
   {
      ix : Int,
      nam : String,
      rnk : String,
      ico : String,
      prt : String,
      lc : Struct.Location.Type,
      hea : Int,
      pla : Int,
      ena : Bool,
      dea : Bool,
      awp : Struct.Weapon.Ref,
      swp : Struct.Weapon.Ref,
      ar : Struct.Armor.Ref,
      omni : Struct.Omnimods.Type
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
      icon : String,
      portrait : String,
      location : Struct.Location.Type,
      health : Int,
      player_ix : Int,
      enabled : Bool,
      defeated : Bool,
      attributes : Struct.Attributes.Type,
      statistics : Struct.Statistics.Type,
      weapons : Struct.WeaponSet.Type,
      armor : Struct.Armor.Type,
      current_omnimods : Struct.Omnimods.Type,
      permanent_omnimods : Struct.Omnimods.Type
   }

type alias TypeAndEquipmentRef =
   {
      char : Type,
      main_weapon_ref : String,
      secondary_weapon_ref : String,
      armor_ref : String
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
      weapon_set = (Struct.WeaponSet.new Struct.Weapon.none Struct.Weapon.none)
      armor = Struct.Armor.none
      default_attributes = (Struct.Attributes.default)
      almost_char =
         {
            ix = add_char.ix,
            name = add_char.nam,
            rank = (str_to_rank add_char.rnk),
            icon = add_char.ico,
            portrait = add_char.prt,
            location = add_char.lc,
            health = add_char.hea,
            attributes = default_attributes,
            statistics = (Struct.Statistics.new_raw default_attributes),
            player_ix = add_char.pla,
            enabled = add_char.ena,
            defeated = add_char.dea,
            weapons = weapon_set,
            armor = armor,
            current_omnimods = (Struct.Omnimods.new [] [] [] []),
            permanent_omnimods = add_char.omni
         }
   in
      {
         char = almost_char,
         main_weapon_ref = add_char.awp,
         secondary_weapon_ref = add_char.swp,
         armor_ref = add_char.ar
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

get_icon_id : Type -> String
get_icon_id c = c.icon

get_portrait_id : Type -> String
get_portrait_id c = c.portrait

get_current_health : Type -> Int
get_current_health c = c.health

get_current_omnimods : Type -> Struct.Omnimods.Type
get_current_omnimods c = c.current_omnimods

get_sane_current_health : Type -> Int
get_sane_current_health c = (max 0 c.health)

set_current_health : Int -> Type -> Type
set_current_health health c = {c | health = health}

get_location : Type -> Struct.Location.Type
get_location t = t.location

set_location : Struct.Location.Type -> Type -> Type
set_location location char = {char | location = location}

get_attributes : Type -> Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Struct.Statistics.Type
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

get_weapons : Type -> Struct.WeaponSet.Type
get_weapons char = char.weapons

get_armor : Type -> Struct.Armor.Type
get_armor char = char.armor

get_armor_variation : Type -> String
get_armor_variation char =
   case char.portrait of
      -- Currently hardcoded to match crows from characters.css
      "11" -> "1"
      "4" -> "1"
      _ -> "0"

set_weapons : Struct.WeaponSet.Type -> Type -> Type
set_weapons weapons char =
   {char |
      weapons = weapons
   }

decoder : (Json.Decode.Decoder TypeAndEquipmentRef)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.succeed
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "rnk" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "ico" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "prt" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "lc" Struct.Location.decoder)
         |> (Json.Decode.Pipeline.required "hea" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "pla" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "ena" Json.Decode.bool)
         |> (Json.Decode.Pipeline.required "dea" Json.Decode.bool)
         |> (Json.Decode.Pipeline.required "awp" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "swp" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "ar" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "pomni" Struct.Omnimods.decoder)
      )
   )

refresh_omnimods : (
      (Struct.Location.Type -> Struct.Omnimods.Type) ->
      Type ->
      Type
   )
refresh_omnimods tile_omnimods_fun char =
   let
      previous_max_health = (Struct.Statistics.get_max_health char.statistics)
      current_omnimods =
         (Struct.Omnimods.merge
            (Struct.Weapon.get_omnimods
               (Struct.WeaponSet.get_active_weapon char.weapons)
            )
            (Struct.Omnimods.merge
               (tile_omnimods_fun char.location)
               char.permanent_omnimods
            )
         )
      current_attributes =
         (Struct.Omnimods.apply_to_attributes
            current_omnimods
            (Struct.Attributes.default)
         )
      current_statistics =
         (Struct.Omnimods.apply_to_statistics
            current_omnimods
            (Struct.Statistics.new_raw current_attributes)
         )
      new_max_health = (Struct.Statistics.get_max_health current_statistics)
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
      (Struct.Location.Type -> Struct.Omnimods.Type) ->
      Struct.Weapon.Type ->
      Struct.Weapon.Type ->
      Struct.Armor.Type ->
      Type ->
      Type
   )
fill_missing_equipment_and_omnimods tile_omnimods_fun awp swp ar char =
   (set_current_health
      -- We just changed the omnimods, but already had the right health value
      char.health
      (refresh_omnimods
         (tile_omnimods_fun)
         {char |
            weapons = (Struct.WeaponSet.new awp swp),
            armor = ar
         }
      )
   )
