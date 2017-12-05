module ElmModule.Subscriptions exposing (..)

import Struct.Model
import Struct.Event

subscriptions : Struct.Model.Type -> (Sub Struct.Event.Type)
subscriptions model = Sub.none
