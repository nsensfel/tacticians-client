module View.SignUp exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.article
      []
      [
         (Html.div
            [
               (Html.Attributes.class "user-input")
            ]
            [
               (Html.h1 [] [(Html.text "Username")]),
               (Html.input [] [])
            ]
         ),
         (Html.p
            []
            [
               (Html.text
                  """
                  This username is used to log in. It also lets other players
                  find your profile.
                  """
               )
            ]
         ),
         (Html.p
            []
            [
               (Html.text
                  """
                  Usernames are not permanent. Players can change their
                  username once a month. Additionally, usernames of players
                  that have been inactive for more than six months can be
                  re-used. Players whose usernames have been taken will have
                  to go through account recovery and choose a new one.
                  """
                  -- TODO username content rules
               )
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "user-input")
            ]
            [
               (Html.h1 [] [(Html.text "Password")]),
               (Html.div
                  [
                     (Html.Attributes.class "multi-input")
                  ]
                  [
                     (Html.input
                        [
                           (Html.Attributes.type_ "password")
                        ]
                        []
                     ),
                     (Html.input
                        [
                           (Html.Attributes.type_ "password")
                        ]
                        []
                     )
                  ]
               )
            ]
         ),
         (Html.p
            []
            [
               (Html.text
                  """
                  Passwords are salted and hashed before storage, as per
                  standard security recommendations.
                  """
               )
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "user-input")
            ]
            [
               (Html.h1 [] [(Html.text "Email")]),
               (Html.div
                  [
                     (Html.Attributes.class "multi-input")
                  ]
                  [
                     (Html.input
                        [
                        ]
                        []
                     ),
                     (Html.input
                        [
                        ]
                        []
                     )
                  ]
               )
            ]
         ),
         (Html.p
            []
            [
               (Html.text
                  """
                  The only two uses of emails are account recovery and
                  the notifications you opt-in for. You will not receive an
                  email to activate your account. This field is optional, leave
                  it empty if you do not wish to give an email address (you can
                  always change your mind later). However, be warned: not having
                  any means to recover your account is likely to lead to the
                  loss of this account (for example, if your username gets taken
                  during an inactivity period).
                  """
               )
            ]
         ),
         (Html.button
            []
            [ (Html.text "Send") ]
         )
      ]
   )
