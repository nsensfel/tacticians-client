module Constants.IO exposing (..)

base_url : String
base_url = "__CONF_SERVER_URL"

login_handler_url : String
login_handler_url = (base_url ++ "/handler/login")

login_sign_in_handler : String
login_sign_in_handler = (login_handler_url ++ "/plr_sign_in")

login_sign_up_handler : String
login_sign_up_handler = (login_handler_url ++ "/plr_sign_up")
