module View.CurrentTab exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import View.CharacterSelection
import View.PortraitSelection
import View.WeaponSelection
import View.ArmorSelection
import View.GlyphManagement

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.get_displayed_tab model.ui) of
      Struct.UI.CharacterSelectionTab ->
         (View.CharacterSelection.get_html model)

      Struct.UI.PortraitSelectionTab ->
         (View.PortraitSelection.get_html model)

      Struct.UI.WeaponSelectionTab ->
         (View.WeaponSelection.get_html model)

      Struct.UI.ArmorSelectionTab ->
         (View.ArmorSelection.get_html model)

      Struct.UI.GlyphManagementTab ->
         (View.GlyphManagement.get_html model)
