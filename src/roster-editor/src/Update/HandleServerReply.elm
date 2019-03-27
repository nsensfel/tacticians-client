module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

import Http

import Url

-- Shared ----------------------------------------------------------------------
import Action.Ports

import Struct.Flags

import Util.Http

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard

-- Local Module ----------------------------------------------------------------
import Constants.IO

import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Inventory
import Struct.Model
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
weapon_getter : (
      Struct.Model.Type ->
      BattleCharacters.Struct.Weapon.Ref ->
      BattleCharacters.Struct.Weapon.Type
   )
weapon_getter model ref =
   case (Dict.get ref model.weapons) of
      (Just w) -> w
      Nothing -> BattleCharacters.Struct.Weapon.none

armor_getter : (
      Struct.Model.Type ->
      BattleCharacters.Struct.Armor.Ref ->
      BattleCharacters.Struct.Armor.Type
   )
armor_getter model ref =
   case (Dict.get ref model.armors) of
      (Just w) -> w
      Nothing -> BattleCharacters.Struct.Armor.none

portrait_getter : (
      Struct.Model.Type ->
      BattleCharacters.Struct.Portrait.Ref ->
      BattleCharacters.Struct.Portrait.Type
   )
portrait_getter model ref =
   case (Dict.get ref model.portraits) of
      (Just w) -> w
      Nothing -> BattleCharacters.Struct.Portrait.default

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
                        "/roster-editor/?"
                        ++ (Struct.Flags.get_params_as_url model.flags)
                     )
                  )
               )
            )
         ]
      )

goto : (
      String ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
goto url current_state =
   let (model, cmds) = current_state in
      (
         model,
         [
            (Action.Ports.go_to (Constants.IO.base_url ++ "/" ++ url))
         ]
      )

add_armor : (
      BattleCharacters.Struct.Armor.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_armor ar current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_armor ar model), cmds)

add_portrait : (
      BattleCharacters.Struct.Portrait.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_portrait pt current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_portrait pt model), cmds)

add_glyph : (
      BattleCharacters.Struct.Glyph.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_glyph gl current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_glyph gl model), cmds)

add_glyph_board : (
      BattleCharacters.Struct.GlyphBoard.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_glyph_board glb current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_glyph_board glb model), cmds)

add_weapon : (
      BattleCharacters.Struct.Weapon.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_weapon wp current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_weapon wp model), cmds)

set_inventory : (
      Struct.Inventory.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_inventory inv current_state =
   let (model, cmds) = current_state in
      ({model | inventory = inv}, cmds)

add_character : (
      Struct.Character.Unresolved ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_character char_ref current_state =
   let (model, cmds) = current_state in
      (
         (Struct.Model.add_unresolved_character char_ref model),
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

      (Struct.ServerReply.GoTo url) -> (goto url current_state)

      (Struct.ServerReply.AddWeapon wp) ->
         (add_weapon wp current_state)

      (Struct.ServerReply.SetInventory inv) ->
         (set_inventory inv current_state)

      (Struct.ServerReply.AddArmor ar) ->
         (add_armor ar current_state)

      (Struct.ServerReply.AddPortrait pt) ->
         (add_portrait pt current_state)

      (Struct.ServerReply.AddGlyph gl) ->
         (add_glyph gl current_state)

      (Struct.ServerReply.AddGlyphBoard glb) ->
         (add_glyph_board glb current_state)

      (Struct.ServerReply.AddCharacter char) ->
         (add_character char current_state)


      Struct.ServerReply.Okay ->
         let (model, cmds) = current_state in
            (
               (Struct.Model.resolve_all_characters model),
               cmds
            )

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
               (Struct.Error.new
                  Struct.Error.Networking
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
