module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Map -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Html

import View.AccountRecovery
import View.Header
import View.MainMenu
import View.SignIn
import View.SignUp

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
         (Html.main_
            [
            ]
            [
               (View.MainMenu.get_html
                  (Struct.UI.try_getting_displayed_tab model.ui)
               ),
               (
                  case (Struct.UI.try_getting_displayed_tab model.ui) of
                     (Just Struct.UI.SignInTab) -> (View.SignIn.get_html model)
                     (Just Struct.UI.SignUpTab) -> (View.SignUp.get_html model)
                     (Just Struct.UI.RecoveryTab) ->
                        (View.AccountRecovery.get_html model)

                     _ -> (View.SignIn.get_html model)
               ),
               (
                  case model.error of
                     Nothing -> (Util.Html.nothing)
                     (Just err) ->
                        (Html.div
                           [
                              (Html.Attributes.class "error-msg")
                           ]
                           [
                              (Html.text (Struct.Error.to_string err))
                           ]
                        )
               )
            ]
         )
      ]
   )
