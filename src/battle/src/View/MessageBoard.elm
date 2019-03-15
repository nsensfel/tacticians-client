module View.MessageBoard exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

import View.MessageBoard.Animator
import View.MessageBoard.Error
import View.MessageBoard.Help

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (model.error) of
      (Just error) -> (View.MessageBoard.Error.get_html model error)
      Nothing ->
         case model.animator of
            (Just animator) ->
               (View.MessageBoard.Animator.get_html model animator)

            Nothing -> (View.MessageBoard.Help.get_html model)
