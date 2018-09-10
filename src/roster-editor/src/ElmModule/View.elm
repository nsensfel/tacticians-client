module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Lazy
import Html.Attributes

-- Map -------------------------------------------------------------------
import Constants.UI

import Struct.Event
import Struct.Model

import View.MessageBoard
import View.MainMenu
import View.CharacterSelection
import View.PortraitSelection
import View.WeaponSelection
import View.

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
