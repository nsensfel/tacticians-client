module Update.SetToolboxMode exposing (apply_to)
-- Elm -------------------------------------------------------------------------

-- Map Editor ------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Toolbox
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Toolbox.Mode ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model mode =
   (
      {model |
         toolbox = (Struct.Toolbox.set_mode mode model.toolbox),
         ui =
            (
               case mode of
                  Struct.Toolbox.Draw ->
                     (Struct.UI.set_displayed_tab Struct.UI.TilesTab model.ui)

                  Struct.Toolbox.Focus ->
                     (Struct.UI.set_displayed_tab Struct.UI.StatusTab model.ui)

                  _ -> model.ui
            )
      },
      Cmd.none
   )
