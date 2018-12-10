module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import Update.GoToMainMenu
import Update.HandleServerReply
import Update.JoinBattle
import Update.SelectCharacter
import Update.SelectTab
import Update.SendRoster
import Update.SetArmor
import Update.SetGlyph
import Update.SetGlyphBoard
import Update.SetName
import Update.SetPortrait
import Update.SetRequestedHelp
import Update.SetWeapon
import Update.ToggleBattleIndex

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

update : (
      Struct.Event.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
update event model =
   let
      new_model = (Struct.Model.clear_error model)
   in
   case event of
      Struct.Event.None -> (model, Cmd.none)

      (Struct.Event.Failed err) ->
         (
            (Struct.Model.invalidate err new_model),
            Cmd.none
         )

      (Struct.Event.CharacterSelected char_id) ->
         (Update.SelectCharacter.apply_to
            (Struct.Model.save_character new_model)
            char_id
         )

      (Struct.Event.ToggleCharacterBattleIndex char_id) ->
         (Update.ToggleBattleIndex.apply_to
            (Struct.Model.save_character new_model)
            char_id
         )

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to
            (
               case tab of
                  Struct.UI.CharacterSelectionTab ->
                     (Struct.Model.save_character new_model)

                  _ -> new_model
            )
            tab
         )

      Struct.Event.SaveRequest ->
         (Update.SendRoster.apply_to (Struct.Model.save_character new_model))

      Struct.Event.GoRequest ->
         (Update.JoinBattle.apply_to (Struct.Model.save_character new_model))

      (Struct.Event.SetCharacterName name) ->
         (Update.SetName.apply_to new_model name)

      (Struct.Event.ClickedOnWeapon is_main) ->
         (Update.SelectTab.apply_to
            {model |
               ui = (Struct.UI.set_is_selecting_main_weapon is_main model.ui)
            }
            Struct.UI.WeaponSelectionTab
         )

      (Struct.Event.ServerReplied result) ->
         (Update.HandleServerReply.apply_to model result)

      (Struct.Event.RequestedHelp help_request) ->
         (Update.SetRequestedHelp.apply_to new_model help_request)

      Struct.Event.GoToMainMenu ->
         (Update.GoToMainMenu.apply_to new_model)

      (Struct.Event.SelectedPortrait ref) ->
         (Update.SetPortrait.apply_to new_model ref)

      (Struct.Event.SelectedArmor ref) ->
         (Update.SetArmor.apply_to new_model ref)

      (Struct.Event.SelectedWeapon ref) ->
         (Update.SetWeapon.apply_to new_model ref)

      (Struct.Event.SelectedGlyph ref) ->
         (Update.SetGlyph.apply_to new_model ref)

      (Struct.Event.ClickedOnGlyph index) ->
         (Update.SelectTab.apply_to
            {model |
               ui = (Struct.UI.set_glyph_slot index model.ui)
            }
            Struct.UI.GlyphSelectionTab
         )

      (Struct.Event.SelectedGlyphBoard ref) ->
         (Update.SetGlyphBoard.apply_to new_model ref)
