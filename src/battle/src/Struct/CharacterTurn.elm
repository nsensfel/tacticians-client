module Struct.CharacterTurn exposing
   (
      Type,
      Action(..),

      -- Active Character
      maybe_get_active_character,
      get_active_character_index,
      set_active_character,
      clear_active_character,
      has_active_character,

      -- Action
      set_action,
      get_action,
      clear_action,

      -- Target Indices
      add_target_index,
      remove_target_index,
      toggle_target_index,
      get_target_indices,
      set_target_indices,
      clear_target_indices,

      -- Locations
      add_location,
      remove_location,
      toggle_location,
      get_locations,
      set_locations,
      clear_locations,

      -- Navigator
      maybe_get_navigator,
      set_navigator,
      clear_navigator,

      -- Path
      get_path,
      store_path,
      override_path,
      clear_path,

      -- Other
      encode,
      new
   )

-- Elm -------------------------------------------------------------------------
import Json.Encode

import Set

-- Shared ----------------------------------------------------------------------
import Shared.Util.Set

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

      navigator : (Maybe Struct.Navigator.Type),
      path : (List BattleMap.Struct.Direction.Type),

      action : Action,
      targets : (Set.Set Int),
      locations : (Set.Set BattleMap.Struct.Location.Ref)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
encode_path : Type -> (Json.Encode.Value)
encode_path ct =
   (Json.Encode.object
      [
         ("cat", (Json.Encode.string "mov")),
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
                     ("cat", (Json.Encode.string "atk")),
                     ("tar", (Json.Encode.int target))
                  ]
               )

      SwitchingWeapons ->
         (Json.Encode.object [("cat", (Json.Encode.string "swp"))])

      UsingSkill ->
         (Json.Encode.object
            [
               ("cat", (Json.Encode.string "skl")),
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
                     (
                        (BattleMap.Struct.Location.from_ref)
                        >>
                        (BattleMap.Struct.Location.encode)
                     )
                     (Set.toList ct.locations)
                  )
               )
            ]
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      active_character = Nothing,

      navigator = Nothing,
      path = [],

      action = None,
      targets = (Set.empty),
      locations = (Set.empty)
   }

---- Active Character ----------------------------------------------------------
maybe_get_active_character : Type -> (Maybe Struct.Character.Type)
maybe_get_active_character ct = ct.active_character

set_active_character : Struct.Character.Type -> Type -> Type
set_active_character char ct = {ct | active_character = (Just char)}

clear_active_character : Type -> Type
clear_active_character ct = {ct | active_character = Nothing}

get_active_character_index : Type -> Int
get_active_character_index ct =
   case ct.active_character of
      Nothing -> -1
      (Just char) -> (Struct.Character.get_index char)

has_active_character : Type -> Bool
has_active_character ct = (ct.active_character /= Nothing)

---- Action --------------------------------------------------------------------
set_action : Action -> Type -> Type
set_action act ct = {ct | action = act}

get_action : Type -> Action
get_action ct = ct.action

clear_action : Type -> Type
clear_action ct = {ct | action = None}

---- Targets -------------------------------------------------------------------
add_target_index : Int -> Type -> Type
add_target_index ix ct = {ct | targets = (Set.insert ix ct.targets)}

remove_target_index : Int -> Type -> Type
remove_target_index ix ct = {ct | targets = (Set.remove ix ct.targets)}

toggle_target_index : Int -> Type -> Type
toggle_target_index ix ct =
   {ct | targets = (Shared.Util.Set.toggle ix ct.targets)}

get_target_indices : Type -> (Set.Set Int)
get_target_indices ct = ct.targets

set_target_indices : (Set.Set Int) -> Type -> Type
set_target_indices targets ct = {ct | targets = targets}

clear_target_indices : Type -> Type
clear_target_indices ct = {ct | targets = (Set.empty)}

---- Locations -----------------------------------------------------------------
add_location : BattleMap.Struct.Location.Ref -> Type -> Type
add_location ix ct = {ct | locations = (Set.insert ix ct.locations)}

remove_location : BattleMap.Struct.Location.Ref -> Type -> Type
remove_location ix ct = {ct | locations = (Set.remove ix ct.locations)}

toggle_location : BattleMap.Struct.Location.Ref -> Type -> Type
toggle_location ix ct =
   {ct | locations = (Shared.Util.Set.toggle ix ct.locations)}

get_locations : Type -> (Set.Set BattleMap.Struct.Location.Ref)
get_locations ct = ct.locations

set_locations : (Set.Set BattleMap.Struct.Location.Ref) -> Type -> Type
set_locations locations ct = {ct | locations = locations}

clear_locations : Type -> Type
clear_locations ct = {ct | locations = (Set.empty)}

---- Navigator -----------------------------------------------------------------
maybe_get_navigator : Type -> (Maybe Struct.Navigator.Type)
maybe_get_navigator ct = ct.navigator

set_navigator : Struct.Navigator.Type -> Type -> Type
set_navigator navigator ct = {ct | navigator = (Just navigator)}

clear_navigator : Type -> Type
clear_navigator ct = {ct | navigator = Nothing}

---- Path ----------------------------------------------------------------------
get_path : Type -> (List BattleMap.Struct.Direction.Type)
get_path ct = ct.path

store_path : Type -> Type
store_path ct =
   {ct |
      path =
         case ct.navigator of
            (Just navigator) -> (Struct.Navigator.get_path navigator)
            Nothing -> []
   }

override_path : (List BattleMap.Struct.Direction.Type) -> Type -> Type
override_path path ct = {ct | path = path}

clear_path : Type -> Type
clear_path ct = {ct | path = []}

---- Encode/Decode -------------------------------------------------------------
encode : Type -> (Json.Encode.Value)
encode ct =
   case ct.active_character of
      Nothing ->
         (Json.Encode.object
            [
               ("cix", (Json.Encode.int 0)),
               ("act", (Json.Encode.list (\a -> a) []))
            ]
         )

      (Just actor) ->
         (Json.Encode.object
            [
               ("cix", (Json.Encode.int (Struct.Character.get_index actor))),
               (
                  "act",
                  (Json.Encode.list
                     (\a -> a)
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
               )
            ]
         )

