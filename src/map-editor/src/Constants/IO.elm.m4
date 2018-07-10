module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

map_editor_handler_url : String
map_editor_handler_url = (base_url ++ "/handler/map-editor")

map_update_handler : String
map_update_handler = (map_editor_handler_url ++ "/me_update")

map_loading_handler : String
map_loading_handler = (map_edit_handler_url ++ "/me_load_state")

tile_assets_url : String
tile_assets_url = (base_url ++ "/asset/svg/tile/")
