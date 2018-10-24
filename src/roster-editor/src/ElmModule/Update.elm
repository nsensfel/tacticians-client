module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Event
import Struct.Glyph
import Struct.GlyphBoard
import Struct.Model
import Struct.Portrait
import Struct.Weapon

import Update.GoToMainMenu
import Update.HandleServerReply
import Update.SelectCharacter
import Update.SelectTab
import Update.SetArmor
import Update.SetGlyph
import Update.SetGlyphBoard
import Update.SetPortrait
import Update.SetRequestedHelp
import Update.SetWeapon

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
         (Update.SelectCharacter.apply_to new_model char_id)

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to new_model tab)

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

      (Struct.Event.SelectedGlyph (ref, index)) ->
         (Update.SetGlyph.apply_to new_model ref index)

      (Struct.Event.SelectedGlyphBoard ref) ->
         (Update.SetGlyphBoard.apply_to new_model ref)
