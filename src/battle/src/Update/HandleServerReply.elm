module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Delay

import Dict

import Http

import Time

import Url

-- Shared ----------------------------------------------------------------------
import Action.Ports

import Struct.Flags

import Util.Http

-- Battle ----------------------------------------------------------------------
import Constants.IO

import Struct.Armor
import Struct.Player
import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Map
import Struct.Model
import Struct.Portrait
import Struct.ServerReply
import Struct.Tile
import Struct.TurnResult
import Struct.TurnResultAnimator
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

portrait_getter : (
      Struct.Model.Type ->
      Struct.Portrait.Ref ->
      Struct.Portrait.Type
   )
portrait_getter model ref =
   case (Dict.get ref model.portraits) of
      (Just w) -> w
      Nothing -> Struct.Portrait.none

-----------

disconnected : (
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
disconnected current_state =
   let (model, cmds) = current_state in
      (
         model,
         [
            (Action.Ports.go_to
               (
                  Constants.IO.base_url
                  ++ "/login/?action=disconnect&goto="
                  ++
                  (Url.percentEncode
                     (
                        "/battle/?"
                        ++ (Struct.Flags.get_params_as_url model.flags)
                     )
                  )
               )
            )
         ]
      )

add_armor : (
      Struct.Armor.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_armor ar current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_armor ar model), cmds)

add_portrait : (
      Struct.Portrait.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_portrait pt current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_portrait pt model), cmds)

add_tile : (
      Struct.Tile.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_tile tl current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_tile tl model), cmds)

add_weapon : (
      Struct.Weapon.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_weapon wp current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_weapon wp model), cmds)

add_player : (
      Struct.Player.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_player pl current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_player pl model), cmds)

add_character : (
      Struct.Character.TypeAndEquipmentRef ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_character char_and_refs current_state =
   let
      (model, cmds) = current_state
      awp = (weapon_getter model char_and_refs.main_weapon_ref)
      swp = (weapon_getter model char_and_refs.secondary_weapon_ref)
      ar = (armor_getter model char_and_refs.armor_ref)
      pt = (portrait_getter model char_and_refs.portrait_ref)
   in
      (
         (Struct.Model.add_character
            (Struct.Character.fill_missing_equipment_and_omnimods
               (Struct.Model.tile_omnimods_fun model)
               pt
               awp
               swp
               ar
               char_and_refs.char
            )
            model
         ),
         cmds
      )

set_map : (
      Struct.Map.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_map map current_state =
   let (model, cmds) = current_state in
      (
         {model |
            map = (Struct.Map.solve_tiles model.tiles map)
         },
         cmds
      )

add_to_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_to_timeline turn_results current_state =
   let (model, cmds) = current_state in
      (
         {model |
            animator =
               (Struct.TurnResultAnimator.maybe_new
                  (List.reverse turn_results)
                  False
               ),
            timeline =
               (Array.append
                  (Array.fromList turn_results)
                  model.timeline
               ),
            ui =
               (Struct.UI.set_displayed_tab
                  Struct.UI.TimelineTab
                  model.ui
               )
         },
         (
            (Delay.after 1 Delay.Millisecond Struct.Event.AnimationEnded)
            :: cmds
         )
      )

set_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_timeline turn_results current_state =
   let (model, cmds) = current_state in
      (
         {model | timeline = (Array.fromList turn_results)},
         cmds
      )

apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_command command current_state =
   case command of
      Struct.ServerReply.Disconnected -> (disconnected current_state)

      (Struct.ServerReply.AddWeapon wp) ->
         (add_weapon wp current_state)

      (Struct.ServerReply.AddArmor ar) ->
         (add_armor ar current_state)

      (Struct.ServerReply.AddPortrait pt) ->
         (add_portrait pt current_state)

      (Struct.ServerReply.AddPlayer pl) ->
         (add_player pl current_state)

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
               (Struct.Error.new Struct.Error.Networking
                  (Util.Http.error_to_string error)
               )
               model
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         let
            (new_model, elm_commands) =
               (List.foldl (apply_command) (model, [Cmd.none]) commands)
         in
            (
               new_model,
               (
                  case elm_commands of
                     [] -> Cmd.none
                     [cmd] -> cmd
                     _ -> (Cmd.batch elm_commands)
               )
            )
