module Update.SelectTile exposing (apply_to)

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.UI
import Struct.Model
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      BattleMap.Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model loc_ref =
   if ((Struct.Toolbox.get_mode model.toolbox) == Struct.Toolbox.Focus)
   then
      (
         {model |
            ui =
               (Struct.UI.set_previous_action
                  (Just (Struct.UI.SelectedLocation loc_ref))
                  (Struct.UI.set_displayed_tab
                     Struct.UI.StatusTab
                     model.ui
                  )
               )
         },
         Cmd.none
      )
   else
      let
         (toolbox, map) =
            (Struct.Toolbox.apply_to
               (BattleMap.Struct.Location.from_ref loc_ref)
               model.toolbox
               model.map
            )
      in
         (
            {model |
               toolbox = toolbox,
               map = map
            },
            Cmd.none
         )
