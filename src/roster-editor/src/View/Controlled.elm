module View.Controlled exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Lazy

-- Local Module ----------------------------------------------------------------
import Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

import View.CharacterCard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case model.edited_char of
      Nothing -> (Util.Html.nothing)
      (Just char) ->
         (Html.div
            [(Html.Attributes.class "controlled")]
            [
               (Html.Lazy.lazy
                  (View.CharacterCard.get_full_html)
                  char
               )
            ]
         )
