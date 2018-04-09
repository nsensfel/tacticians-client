module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

battlemap_handler_url : String
battlemap_handler_url = (base_url ++ "/handler/battlemap")

character_turn_handler : String
character_turn_handler = (battlemap_handler_url ++ "/character_turn")

battlemap_loading_handler : String
battlemap_loading_handler = (battlemap_handler_url ++ "/load_state")

tile_assets_url : String
tile_assets_url = (base_url ++ "/asset/svg/tile/")
