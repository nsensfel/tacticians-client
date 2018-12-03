module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Main Menu -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model

import View.Header
import View.CurrentTab

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
         (View.Header.get_html),
         (View.CurrentTab.get_html model),
         (
            case model.error of
               Nothing -> (Util.Html.nothing)
               (Just err) ->
                  (Html.div
                     []
                     [
                        (Html.text (Struct.Error.to_string err))
                     ]
                  )
         )
      ]
   )
