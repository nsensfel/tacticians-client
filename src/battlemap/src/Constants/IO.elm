module Constants.IO exposing (..)

base_url : String
--base_url = "https://tacticians.online"
base_url = "http://127.0.0.1"

battlemap_handler_url : String
battlemap_handler_url = (base_url ++ "/handler/battlemap")

character_turn_handler : String
character_turn_handler = (battlemap_handler_url ++ "/character_turn.yaws")

battlemap_loading_handler : String
battlemap_loading_handler = (battlemap_handler_url ++ "/load_state.yaws")
