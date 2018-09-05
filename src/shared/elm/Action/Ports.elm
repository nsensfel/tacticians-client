port module Action.Ports exposing (..)

port store_new_session : (String, String) -> (Cmd msg)
port reset_session : () -> (Cmd msg)
port connected: (() -> msg) -> (Sub msg)
port go_to : (String) -> (Cmd msg)
