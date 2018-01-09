module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Error
import Struct.UI
import Struct.Model

import Update.ChangeScale
import Update.EndTurn
import Update.HandleServerReply
import Update.RequestDirection
import Update.SelectCharacter
import Update.SelectTab
import Update.SelectTile
import Update.SendLoadBattlemapRequest
import Update.SwitchTeam

import Send.LoadBattlemap

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
      (Struct.Event.DirectionRequested d) ->
         (Update.RequestDirection.apply_to new_model d)

      (Struct.Event.TileSelected loc) ->
         (Update.SelectTile.apply_to new_model loc)

      (Struct.Event.CharacterSelected char_id) ->
         (Update.SelectCharacter.apply_to new_model char_id)

      Struct.Event.TurnEnded ->
         (Update.EndTurn.apply_to new_model)

      (Struct.Event.ScaleChangeRequested mod) ->
         (Update.ChangeScale.apply_to new_model mod)

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to new_model tab)

      Struct.Event.DebugTeamSwitchRequest ->
         (Update.SwitchTeam.apply_to new_model)

      (Struct.Event.DebugLoadBattlemapRequest) ->
         (Update.SendLoadBattlemapRequest.apply_to new_model)

      (Struct.Event.ServerReplied result) ->
         (Update.HandleServerReply.apply_to model result)
