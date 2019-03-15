module View.Gauge exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_text_div : (
      String ->
      List (Html.Attribute Struct.Event.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_text_div text extra_txt_attr =
   (Html.div
      (
         [(Html.Attributes.class "gauge-text")]
         ++ extra_txt_attr
      )
      [
         (Html.text text)
      ]
   )

get_bar_div : (
      Float ->
      List (Html.Attribute Struct.Event.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_bar_div percent extra_bar_attr =
   (Html.div
      (
         [
            (Html.Attributes.style
               "width"
               ((String.fromFloat percent) ++ "%")
            ),
            (Html.Attributes.class
               "gauge-bar"
            )
         ]
         ++
         extra_bar_attr
      )
      [
      ]
   )


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      String ->
      Float ->
      List (Html.Attribute Struct.Event.Type) ->
      List (Html.Attribute Struct.Event.Type) ->
      List (Html.Attribute Struct.Event.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_html text percent extra_div_attr extra_bar_attr extra_txt_attr =
   (Html.div
      (
         [(Html.Attributes.class "gauge")]
         ++ extra_div_attr
      )
      [
         (get_text_div text extra_txt_attr),
         (get_bar_div percent extra_bar_attr)
      ]
   )
