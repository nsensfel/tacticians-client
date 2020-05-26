module View.SubMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Battle Map ------------------------------------------------------------------
import BattleMap.View.TileInfo

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Event
import Struct.Model
import Struct.UI

import View.Controlled.CharacterCard

import View.SubMenu.CharacterStatus
import View.SubMenu.Characters
import View.SubMenu.Settings
import View.SubMenu.Timeline

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_inner_html : (
      Struct.Model.Type ->
      Struct.UI.Tab ->
      (Html.Html Struct.Event.Type)
   )
get_inner_html model tab =
   case tab of
      (Struct.UI.TileStatusTab tile_loc) ->
         (Html.Lazy.lazy3
            (BattleMap.View.TileInfo.get_html)
            model.map_data_set
            tile_loc
            model.battle.map
         )

      (Struct.UI.CharacterStatusTab char_ref) ->
         case (Struct.Battle.get_character char_ref model.battle) of
            (Just char) ->
               (Html.Lazy.lazy2
                  (View.SubMenu.CharacterStatus.get_html)
                  model.battle.own_player_ix
                  char
               )

            _ -> (Html.text "Error: Unknown character selected.")

      Struct.UI.CharactersTab ->
         (Html.Lazy.lazy2
            (View.SubMenu.Characters.get_html)
            model.battle.characters
            model.battle.own_player_ix
         )

      Struct.UI.SettingsTab ->
         (View.SubMenu.Settings.get_html model)

      Struct.UI.TimelineTab ->
         (View.SubMenu.Timeline.get_html model)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.maybe_get_displayed_tab model.ui) of
      (Just tab) ->
         (Html.div
            [(Html.Attributes.class "sub-menu")]
            [(get_inner_html model tab)]
         )

      Nothing ->
         (Shared.Util.Html.nothing)
