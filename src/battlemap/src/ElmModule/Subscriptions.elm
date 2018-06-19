module ElmModule.Subscriptions exposing (..)

-- Elm -------------------------------------------------------------------------
import Animation

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
subscriptions : Struct.Model.Type -> (Sub Struct.Event.Type)
subscriptions model =
   case model.animation of
      (Just animation) ->
         (Animation.subscription Struct.Event.Animate [animation])

      Nothing -> Sub.none
