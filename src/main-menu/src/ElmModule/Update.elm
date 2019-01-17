module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.HandleNewBattle
import Update.HandleServerReply

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

      (Struct.Event.ServerReplied result) ->
         (Update.HandleServerReply.apply_to model result)

      (Struct.Event.NewBattle (ix, category)) ->
         (Update.HandleNewBattle.apply_to new_model ix category)

      (Struct.Event.BattleSetSize size) ->
         (Update.HandleNewBattle.set_size new_model size)

      (Struct.Event.BattleSetMode mode) ->
         (Update.HandleNewBattle.set_mode new_model mode)

      (Struct.Event.BattleSetMap map_summary) ->
         (Update.HandleNewBattle.set_map new_model map_summary)

      (Struct.Event.TabSelected tab) -> (model, Cmd.none)
