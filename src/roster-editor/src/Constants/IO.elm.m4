module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

roster_handler_url : String
roster_handler_url = (base_url ++ "/handler/roster")

roster_loading_handler : String
roster_loading_handler = (map_handler_url ++ "/rst_load")
