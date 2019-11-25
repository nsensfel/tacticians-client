module Struct.Battle exposing
   (
      Type,
      new,

      add_character,
      get_character,
      set_character,
      update_character,
      get_characters,
      set_characters,

      add_player,
      get_player,
      set_player,
      get_players,
      set_players,

      get_timeline,
      set_timeline,

      get_map,
      set_map,

      get_id,

      get_own_player_index
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Set

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Elm -------------------------------------------------------------------------
import Array

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.Marker
import BattleMap.Struct.DataSet

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.TurnResult
import Struct.Player

import Util.Array

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      map : BattleMap.Struct.Map.Type,
      characters : (Array.Array Struct.Character.Type),
      players : (Array.Array Struct.Player.Type),
      timeline : (Array.Array Struct.TurnResult.Type),

      -- Having this here is kind of a hack.
      own_player_ix : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TODO: move this elsewhere, this is too complicated a function for a module
-- that's not solely focused on attacks of opportunity.
regenerate_attack_of_opportunity_markers_of_char : (
      Int ->
      Struct.Character.Type ->
      Type ->
      Type
   )
regenerate_attack_of_opportunity_markers_of_char char_ix char battle =
   if ((Struct.Character.get_player_index char) == battle.own_player_ix)
   then battle
   else
      let
         marker_name = ("matk_c" ++ (String.fromInt char_ix))
         map_without_this_marker =
            (BattleMap.Struct.Map.remove_marker marker_name battle.map)
      in
         case (Struct.Character.get_melee_attack_range char) of
            0 -> {battle | map = map_without_this_marker}
            attack_range ->
                  {battle |
                     map =
                        (BattleMap.Struct.Map.add_marker
                           marker_name
                           (BattleMap.Struct.Marker.new_melee_attack
                              char_ix
                              (BattleMap.Struct.Location.add_neighborhood_to_set
                                 (BattleMap.Struct.Map.get_width
                                    map_without_this_marker
                                 )
                                 (BattleMap.Struct.Map.get_height
                                    map_without_this_marker
                                 )
                                 attack_range
                                 (Struct.Character.get_location char)
                                 (Set.empty)
                              )
                           )
                           map_without_this_marker
                        )
                  }

regenerate_attack_of_opportunity_markers : Int -> Type -> Type
regenerate_attack_of_opportunity_markers char_ix battle =
   case (Array.get char_ix battle.characters) of
      Nothing -> battle
      (Just char) ->
         (regenerate_attack_of_opportunity_markers_of_char char_ix char battle)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      id = "",
      map = (BattleMap.Struct.Map.empty),
      characters = (Array.empty),
      players = (Array.empty),
      timeline = (Array.empty),

      own_player_ix = -1
   }

--------------------
---- Characters ----
--------------------
add_character : Struct.Character.Type -> Type -> Type
add_character char battle =
   let characters = battle.characters in
      (regenerate_attack_of_opportunity_markers_of_char
         (Array.length characters)
         char
         {battle | characters = (Array.push char characters)}
      )

get_character : Int -> Type -> (Maybe Struct.Character.Type)
get_character ix battle = (Array.get ix battle.characters)

set_character : Int -> Struct.Character.Type -> Type -> Type
set_character ix char battle =
   {battle | characters = (Array.set ix char battle.characters) }

update_character : (
      Int ->
      ((Maybe Struct.Character.Type) -> (Maybe Struct.Character.Type)) ->
      Type ->
      Type
   )
update_character ix fun battle =
   {battle | characters = (Util.Array.update ix (fun) battle.characters) }

get_characters : Type -> (Array.Array Struct.Character.Type)
get_characters battle = battle.characters

set_characters : (Array.Array Struct.Character.Type) -> Type -> Type
set_characters chars battle = {battle | characters = chars}

-----------------
---- Players ----
-----------------
add_player : Struct.Flags.Type -> Struct.Player.Type -> Type -> Type
add_player flags pl battle =
   {battle |
      players = (Array.push pl battle.players),
      own_player_ix =
         if ((Struct.Player.get_id pl) == (Struct.Flags.get_user_id flags))
         then (Array.length battle.players)
         else battle.own_player_ix
   }

get_player : Int -> Type -> (Maybe Struct.Player.Type)
get_player ix battle = (Array.get ix battle.players)

set_player : Int -> Struct.Player.Type -> Type -> Type
set_player ix pl battle =
   {battle | players = (Array.set ix pl battle.players) }

update_player : (
      Int ->
      ((Maybe Struct.Player.Type) -> (Maybe Struct.Player.Type)) ->
      Type ->
      Type
   )
update_player ix fun battle =
   {battle | players = (Util.Array.update ix (fun) battle.players) }

get_players : Type -> (Array.Array Struct.Player.Type)
get_players battle = battle.players

set_players : (Array.Array Struct.Player.Type) -> Type -> Type
set_players pls battle = {battle | players = pls}

------------------
---- Timeline ----
------------------
get_timeline : Type -> (Array.Array Struct.TurnResult.Type)
get_timeline battle = battle.timeline

set_timeline : (Array.Array Struct.TurnResult.Type) -> Type -> Type
set_timeline timeline battle = {battle | timeline = timeline}

-------------
---- Map ----
-------------
get_map : Type -> BattleMap.Struct.Map.Type
get_map battle = battle.map

set_map : BattleMap.Struct.Map.Type -> Type -> Type
set_map map battle = {battle | map = map}

------------
---- ID ----
------------
get_id : Type -> String
get_id battle = battle.id

--------------------------
---- Own Player Index ----
--------------------------
get_own_player_index : Type -> Int
get_own_player_index battle = battle.own_player_ix
