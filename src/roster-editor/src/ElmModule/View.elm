module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Model

import View.Controlled
import View.CurrentTab
import View.MainMenu
import View.MessageBoard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
view : Struct.Model.Type -> (Html.Html Struct.Event.Type)
view model =
   (Html.div
      [
         (Html.Attributes.class "fullscreen-module")
      ]
      [
         (View.MainMenu.get_html),
         (View.CurrentTab.get_html model),
         (View.Controlled.get_html model),
         (View.MessageBoard.get_html model)
      ]
   )
