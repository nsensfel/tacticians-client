module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

map_handler_url : String
map_handler_url = (base_url ++ "/handler/map")

character_turn_handler : String
character_turn_handler = (map_handler_url ++ "/btl_character_turn")

map_loading_handler : String
map_loading_handler = (map_handler_url ++ "/btl_load")

tile_assets_url : String
tile_assets_url = (base_url ++ "/asset/svg/tile/")
