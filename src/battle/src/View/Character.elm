module View.Character exposing (get_portrait_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.View.Portrait

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_portrait_html char =
   (BattleCharacters.View.Portrait.get_html
      [
         (Html.Events.onClick
            (Struct.Event.LookingForCharacter (Struct.Character.get_index char))
         )
         |
         (List.map
            (
               \effect_name ->
               (Html.Attributes.class
                  ("character-portrait-effect-" ++ effect_name)
               )
            )
            (Struct.Character.get_extra_display_effects_list char)
         )
      ]
      (BattleCharacters.Struct.Character.get_equipment
         (Struct.Character.get_base_character char)
      )
   )
