module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

player_handler_url : String
player_handler_url = (base_url ++ "/handler/player")

player_loading_handler : String
player_loading_handler = (player_handler_url ++ "/plr_load")
