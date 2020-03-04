module ElmModule.Update exposing (update)

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.AbortTurn
import Update.AttackWithoutMoving
import Update.ChangeScale
import Update.DisplayCharacterInfo
import Update.EndTurn
import Update.GoToMainMenu
import Update.HandleServerReply
import Update.LookForCharacter
import Update.Puppeteer
import Update.RequestDirection
import Update.SelectCharacter
import Update.SelectCharacterOrTile
import Update.SelectTab
import Update.SelectTile
import Update.SetRequestedHelp
import Update.SwitchWeapon
import Update.UndoAction

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
   case event of
      Struct.Event.None -> (model, Cmd.none)

      (Struct.Event.Failed err) ->
         (
            (Struct.Model.invalidate err model),
            Cmd.none
         )

      Struct.Event.AttackWithoutMovingRequest ->
         (Update.AttackWithoutMoving.apply_to model)

      Struct.Event.AnimationEnded ->
         (Update.Puppeteer.apply_to model)

      (Struct.Event.DirectionRequested d) ->
         (Update.RequestDirection.apply_to model d)

      (Struct.Event.TileSelected loc) ->
         (Update.SelectTile.apply_to model loc)

      (Struct.Event.CharacterOrTileSelected loc) ->
         (Update.SelectCharacterOrTile.apply_to model loc)

      (Struct.Event.CharacterSelected char_id) ->
         (Update.SelectCharacter.apply_to model char_id)

      (Struct.Event.CharacterInfoRequested char_id) ->
         (Update.DisplayCharacterInfo.apply_to model char_id)

      (Struct.Event.LookingForCharacter char_id) ->
         (Update.LookForCharacter.apply_to model char_id)

      Struct.Event.TurnEnded ->
         (Update.EndTurn.apply_to model)

      (Struct.Event.ScaleChangeRequested mod) ->
         (Update.ChangeScale.apply_to model mod)

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to model tab)

      (Struct.Event.ServerReplied result) ->
         (Update.HandleServerReply.apply_to model result)

      Struct.Event.WeaponSwitchRequest ->
         (Update.SwitchWeapon.apply_to model)

      Struct.Event.AbortTurnRequest ->
         (Update.AbortTurn.apply_to model)

      Struct.Event.UndoActionRequest ->
         (Update.UndoAction.apply_to model)

      (Struct.Event.RequestedHelp help_request) ->
         (Update.SetRequestedHelp.apply_to model help_request)

      Struct.Event.GoToMainMenu ->
         (Update.GoToMainMenu.apply_to model)
