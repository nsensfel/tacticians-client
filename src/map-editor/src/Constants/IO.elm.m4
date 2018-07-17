module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

data_url : String
data_url = (base_url ++ "/asset/data/")

tiles_data_url : String
tiles_data_url = (base_url ++ "/asset/data/tiles.json")

tile_patterns_data_url : String
tile_patterns_data_url = (base_url ++ "/asset/data/tile_patterns.json")

map_editor_handler_url : String
map_editor_handler_url = (base_url ++ "/handler/map-editor")

map_update_handler : String
map_update_handler = (map_editor_handler_url ++ "/map_update")

map_loading_handler : String
map_loading_handler = (map_editor_handler_url ++ "/map_load")

tile_assets_url : String
tile_assets_url = (base_url ++ "/asset/svg/tile/")
