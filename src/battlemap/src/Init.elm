module Init exposing (init)

import Model
import Event

import Shim.Model

init : (Model.Type, (Cmd Event.Type))
init = ((Shim.Model.generate), Cmd.none)
