module Subscriptions exposing (..)

import Model
import Event

subscriptions : Model.Type -> (Sub Event.Type)
subscriptions model = Sub.none
