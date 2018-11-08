module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

roster_handler_url : String
roster_handler_url = (base_url ++ "/handler/roster")

roster_loading_handler : String
roster_loading_handler = (roster_handler_url ++ "/rst_load")

roster_update_handler : String
roster_update_handler = (roster_handler_url ++ "/rst_update")

armors_data_url : String
armors_data_url = (base_url ++ "/asset/data/armors.json")

weapons_data_url : String
weapons_data_url = (base_url ++ "/asset/data/weapons.json")

glyph_boards_data_url : String
glyph_boards_data_url = (base_url ++ "/asset/data/glyph_boards.json")

glyphs_data_url : String
glyphs_data_url = (base_url ++ "/asset/data/glyphs.json")

portraits_data_url : String
portraits_data_url = (base_url ++ "/asset/data/portraits.json")
