module Update.HandleNewInvasion exposing
   (
      apply_to,
      set_size,
      set_category,
      set_map
   )
-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.BattleSummary
import Struct.Event
import Struct.InvasionRequest
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
      Struct.InvasionRequest.Size ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_size model size =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None -> -- TODO: err
         (model, Cmd.none)

      (Struct.UI.NewInvasion invasion) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewInvasion
                        (Struct.InvasionRequest.set_size size invasion)
                     )
                     model.ui
                  )
            },
            Cmd.none
         )

set_category : (
      Struct.Model.Type ->
      Struct.BattleSummary.InvasionCategory ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_category model category =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None -> -- TODO: err
         (model, Cmd.none)

      (Struct.UI.NewInvasion invasion) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewInvasion
                        (Struct.InvasionRequest.set_category category invasion)
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

      (Struct.UI.NewInvasion invasion) ->
         (
            {model |
               ui =
                  (Struct.UI.set_action
                     (Struct.UI.NewInvasion
                        (Struct.InvasionRequest.set_map_id
                           ""
                           (Struct.InvasionRequest.set_size
                              -- TODO: get from map summary
                              Struct.InvasionRequest.Small
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
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ix =
   (
      {model |
         ui =
            (Struct.UI.set_action
               (Struct.UI.NewInvasion (Struct.InvasionRequest.new ix))
               model.ui
            )
      },
      Cmd.none
   )
