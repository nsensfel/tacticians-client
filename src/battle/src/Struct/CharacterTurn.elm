module Struct.CharacterTurn exposing
   (
      Type,
      State(..),
      toggle_target_index,
      toggle_location,
      switch_weapons,
      undo_action,
      get_path,
      get_action,
      get_target_indices,
      get_locations,
      lock_path,
      unlock_path,
      show_attack_range_navigator,
      new,
      set_active_character,
      set_active_character_no_reset,
      set_navigator,
      maybe_get_active_character,
      maybe_get_navigator,
      encode
   )

-- Elm -------------------------------------------------------------------------
import Json.Encode

import Set

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Navigator

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Action =
   None
   | Attacking
   | SwitchingWeapons
   | UsingSkill

type alias Type =
   {
      active_character : (Maybe Struct.Character.Type),

      path : (List BattleMap.Struct.Direction.Type),
      navigator : (Maybe Struct.Navigator.Type),

      action : Action,
      targets : (Set.Set Int),
      locations : (Set.Set BattleMap.Struct.Location.Ref)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      active_character = Nothing,

      path = [],
      navigator = Nothing,

      action = None,
      targets = (Set.empty),
      locations = (Set.empty)
   }

maybe_get_active_character : Type -> (Maybe Struct.Character.Type)
maybe_get_active_character ct = ct.active_character

switch_weapons : Type -> Type
switch_weapons : 
toggle_target_index : Int -> Type -> Type
toggle_target_index ix ct =
   let
      uct =
         case ct.action of
            None -> (lock_path ct)
            _ -> ct
   in
      if (Set.member ix uct.targets)
      then {uct | targets = (Set.remove ix uct.targets)}
      else {uct | targets = (Set.insert ix uct.targets)}

toggle_location : BattleMap.Struct.Location.Ref -> Type -> Type
toggle_location loc ct =
   let
      uct =
         case ct.action of
            None -> (lock_path ct)
            _ -> ct
   in
      if (Set.member loc uct.locations)
      then {uct | locations = (Set.remove loc uct.locations)}
      else {uct | locations = (Set.insert loc uct.locations)}

set_active_character : (
      Struct.Character.Type ->
      Type ->
      Type
   )
set_active_character char ct =
   {ct |
      active_character = (Just char),

      path = [],
      navigator = Nothing,

      action = None,
      targets = (Set.empty),
      locations = (Set.empty)
   }

set_active_character_no_reset : (
      Struct.Character.Type ->
      Type ->
      Type
   )
set_active_character_no_reset char ct =
   {ct |
      active_character = (Just char)
   }

get_action : Type -> Action
get_action ct = ct.action

get_path : Type -> (List BattleMap.Struct.Direction.Type)
get_path ct = ct.path

lock_path : Type -> Type
lock_path ct =
   case ct.navigator of
      (Just old_nav) ->
         {ct |
            path = (Struct.Navigator.get_path old_nav),
            navigator = (Just (Struct.Navigator.lock_path old_nav)),

            action = Attacking,
            targets = (Set.empty),
            locations = (Set.empty)
         }

      _ ->
         ct

unlock_path : Type -> Type
unlock_path ct =
   case ct.navigator of
      (Just old_nav) ->
         {ct |
            navigator = (Just (Struct.Navigator.unlock_path old_nav)),

            action = None,
            targets = (Set.empty),
            locations = (Set.empty)
         }

      _ ->
         ct

show_attack_range_navigator : Int -> Int -> Type -> Type
show_attack_range_navigator range_min range_max ct =
   case ct.navigator of
      Nothing -> ct

      (Just old_nav) ->
            {ct |
               path = (Struct.Navigator.get_path old_nav),
               navigator =
                  (Just
                     (Struct.Navigator.lock_path_with_new_attack_ranges
                        range_min
                        range_max
                        old_nav
                     )
                  ),

               action = None,
               targets = (Set.empty),
               locations = (Set.empty)
            }

maybe_get_navigator : Type -> (Maybe Struct.Navigator.Type)
maybe_get_navigator ct = ct.navigator

set_navigator : Struct.Navigator.Type -> Type -> Type
set_navigator navigator ct =
   {ct |
      path = [],
      navigator = (Just navigator),

      action = None,
      targets = (Set.empty),
      locations = (Set.empty)
   }

get_target_indices : Type -> (Set.Set Int)
get_target_indices ct = ct.targets

get_locations : Type -> (Set.Set BattleMap.Struct.Location.Ref)
get_locations ct = ct.locations

encode : Type -> (Json.Encode.Value)
encode ct =
   case ct.active_character of
      None ->
         (Json.Encode.object
            [
               ("cix", 0),
               ("act", [])
            ]
         )

      (Just actor) ->
         (Json.Encode.object
            [
               ("cix", (Struct.Character.get_index actor)),
               (
                  "act",
                  (
                     (
                        if (List.isEmpty (get_path ct))
                        then [(encode_path ct)]
                        else []
                     )
                     ++
                     (
                        if (ct.action == None)
                        then []
                        else [(encode_action ct)]
                     )
                  )
               )
            ]
         )

encode_path : Type -> (Json.Encode.Value)
encode_path ct =
   (Json.Encode.object
      [
         ("cat", "mov"),
         (
            "pat",
            (Json.Encode.list
               (
                  (Json.Encode.string)
                  <<
                  (BattleMap.Struct.Direction.to_string)
               )
               (List.reverse (get_path ct))
            )
         )
      ]
   )

encode_action : Type -> (Json.Encode.Value)
encode_action ct =
   case ct.action of
      None -> (Json.Encode.null)
      Attacking ->
         case (List.head (Set.toList ct.targets)) of
            Nothing -> (Json.Encode.null)
            (Just target) ->
               (Json.Encode.object
                  [
                     ("cat", "atk"),
                     ("tar", (Json.Encode.int target))
                  ]
               )

      SwitchingWeapons ->
         (Json.Encode.object [("cat", "swp")])

      UsingSkill ->
         (Json.Encode.object
            [
               ("cat", "skl"),
               (
                  "tar",
                  (Json.Encode.list
                     (Json.Encode.int)
                     (Set.toList ct.targets)
                  )
               ),
               (
                  "loc",
                  (Json.Encode.list
                     (BattleMap.Struct.Location.encode)
                     (Set.toList ct.locations)
                  )
               )
            ]
         )
