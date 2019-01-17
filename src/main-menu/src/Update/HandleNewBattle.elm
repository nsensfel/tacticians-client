module Update.HandleNewBattle exposing
   (
      apply_to,
      set_size,
      set_category,
      set_mode,
      set_map
   )
-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.BattleSummary
import Struct.Event
import Struct.BattleRequest
import Struct.MapSummary
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
set_size : (
      Struct.Model.Type ->
      Struct.BattleRequest.Size ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_size model size =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None -> -- TODO: err
         (model, Cmd.none)

      (Struct.UI.NewBattle invasion) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewBattle
                        (Struct.BattleRequest.set_size size invasion)
                     )
                     model.ui
                  )
            },
            Cmd.none
         )

set_category : (
      Struct.Model.Type ->
      Struct.BattleSummary.Category ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_category model category =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None -> -- TODO: err
         (model, Cmd.none)

      (Struct.UI.NewBattle battle) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewBattle
                        (Struct.BattleRequest.set_category category battle)
                     )
                     model.ui
                  )
            },
            Cmd.none
         )

set_mode : (
      Struct.Model.Type ->
      Struct.BattleSummary.Mode ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_mode model mode =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None -> -- TODO: err
         (model, Cmd.none)

      (Struct.UI.NewBattle battle) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewBattle
                        (Struct.BattleRequest.set_mode mode battle)
                     )
                     model.ui
                  )
            },
            Cmd.none
         )

set_map : (
      Struct.Model.Type ->
      Struct.MapSummary.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_map model map =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None -> -- TODO: err
         (model, Cmd.none)

      (Struct.UI.NewBattle invasion) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewBattle
                        (Struct.BattleRequest.set_map_id
                           (Struct.MapSummary.get_id map)
                           (Struct.BattleRequest.set_size
                              -- TODO: get from map summary
                              Struct.BattleRequest.Small
                              invasion
                           )
                        )
                     )
                     model.ui
                  )
            },
            Cmd.none
         )

apply_to : (
      Struct.Model.Type ->
      Int ->
      Struct.BattleSummary.Category ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ix category =
   (
      {model |
         ui =
            (Struct.UI.set_action
               (Struct.UI.NewBattle (Struct.BattleRequest.new ix category))
               model.ui
            )
      },
      Cmd.none
   )
