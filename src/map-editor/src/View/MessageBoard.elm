module View.MessageBoard exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model

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
      Nothing -> (View.MessageBoard.Help.get_html model)
