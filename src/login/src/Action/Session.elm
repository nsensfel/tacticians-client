port module Action.Session exposing (..)

port store_new_session : (String, String) -> (Cmd msg)
port reset_session : () -> (Cmd msg)
