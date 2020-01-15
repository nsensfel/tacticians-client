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
import BattleCharacters.Struct.DataSetItem

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
                        ++ (Struct.Flags.get_parameters_as_url model.flags)
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

add_characters_dataset_item : (
      BattleCharacters.Struct.DataSetItem.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_characters_dataset_item item current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSetItem.add_to
                  item
                  model.characters_dataset
               )
         },
         cmds
      )

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

      (Struct.ServerReply.SetInventory inv) ->
         (set_inventory inv current_state)

      (Struct.ServerReply.AddCharactersDataSetItem it) ->
         (add_characters_dataset_item it current_state)

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
