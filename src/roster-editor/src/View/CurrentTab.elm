module View.CurrentTab exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import View.ArmorSelection
import View.CharacterSelection
import View.GlyphManagement
import View.GlyphBoardSelection
import View.GlyphSelection
import View.PortraitSelection
import View.WeaponSelection

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

      Struct.UI.GlyphSelectionTab ->
         (View.GlyphSelection.get_html model)

      Struct.UI.GlyphBoardSelectionTab ->
         (View.GlyphBoardSelection.get_html model)

      Struct.UI.GlyphManagementTab ->
         (View.GlyphManagement.get_html model)
