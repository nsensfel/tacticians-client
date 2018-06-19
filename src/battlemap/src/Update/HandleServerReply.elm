module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Armor
import Struct.Battlemap
import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.ServerReply
import Struct.Tile
import Struct.TurnResult
import Struct.UI
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
weapon_getter : Struct.Model.Type -> Struct.Weapon.Ref -> Struct.Weapon.Type
weapon_getter model ref =
   case (Dict.get ref model.weapons) of
      (Just w) -> w
      Nothing -> Struct.Weapon.none

armor_getter : Struct.Model.Type -> Struct.Armor.Ref -> Struct.Armor.Type
armor_getter model ref =
   case (Dict.get ref model.armors) of
      (Just w) -> w
      Nothing -> Struct.Armor.none

-----------

add_armor : (
      Struct.Armor.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_armor ar current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) -> ((Struct.Model.add_armor ar model), Nothing)

add_tile : (
      Struct.Tile.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_tile tl current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) -> ((Struct.Model.add_tile tl model), Nothing)

add_weapon : (
      Struct.Weapon.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_weapon wp current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) -> ((Struct.Model.add_weapon wp model), Nothing)

add_character : (
      (Struct.Character.Type, Int, Int, Int) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_character char_and_refs current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) ->
         let
            (char, awp_ref, swp_ref, ar_ref) = char_and_refs
            awp = (weapon_getter model awp_ref)
            swp = (weapon_getter model swp_ref)
            ar = (armor_getter model ar_ref)
         in
            (
               (Struct.Model.add_character
                  (Struct.Character.fill_missing_equipment awp swp ar char)
                  model
               ),
               Nothing
            )

set_map : (
      Struct.Battlemap.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
set_map map current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) ->
         (
            {model |
               battlemap =
                  (Struct.Battlemap.solve_tiles (Dict.values model.tiles) map)
            },
            Nothing
         )

add_to_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_to_timeline turn_results current_state =
   case current_state of
      (_, (Just _)) -> current_state

      (model, _) ->
         let
            updated_characters =
               (List.foldl
                  (Struct.TurnResult.apply_to_characters)
                  model.characters
                  turn_results
               )
         in
            (
               {model |
                  timeline =
                     (Array.append
                        (Array.fromList turn_results)
                        model.timeline
                     ),
                  ui =
                     (Struct.UI.set_displayed_tab
                        Struct.UI.TimelineTab
                        model.ui
                     ),
                  characters = updated_characters
               },
               Nothing
            )

set_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
set_timeline turn_results current_state =
   case current_state of
      (_, (Just _)) -> current_state

      (model, _) ->
         (
            {model | timeline = (Array.fromList turn_results)},
            Nothing
         )

apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
apply_command command current_state =
   case command of
      (Struct.ServerReply.AddWeapon wp) ->
         (add_weapon wp current_state)

      (Struct.ServerReply.AddArmor ar) ->
         (add_armor ar current_state)

      (Struct.ServerReply.AddTile tl) ->
         (add_tile tl current_state)

      (Struct.ServerReply.AddCharacter char) ->
         (add_character char current_state)

      (Struct.ServerReply.SetMap map) ->
         (set_map map current_state)

      (Struct.ServerReply.TurnResults results) ->
         (add_to_timeline results current_state)

      (Struct.ServerReply.SetTimeline timeline) ->
         (set_timeline timeline current_state)

      Struct.ServerReply.Okay -> current_state

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Result Http.Error (List Struct.ServerReply.Type)) ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model query_result =
   case query_result of
      (Result.Err error) ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new Struct.Error.Networking (toString error))
               model
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         (
            (
               case (List.foldl (apply_command) (model, Nothing) commands) of
                  (updated_model, Nothing) -> updated_model
                  (_, (Just error)) -> (Struct.Model.invalidate error model)
            ),
            Cmd.none
         )
