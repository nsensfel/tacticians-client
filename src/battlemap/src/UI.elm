module UI exposing
   (
      Type,
      Tab(..),
      default,
      get_zoom_level,
      reset_zoom_level,
      mod_zoom_level
   )

type alias Type =
   {
      zoom_level : Float,
      show_manual_controls : Bool
   }

type Tab =
   NoTab
   | StatusTab
   | SettingsTab

default : Type
default =
   {
      zoom_level = 1.0,
      show_manual_controls = True
   }

get_zoom_level : Type -> Float
get_zoom_level ui = ui.zoom_level

reset_zoom_level : Type -> Type
reset_zoom_level ui = {ui | zoom_level = 1.0}

mod_zoom_level : Type -> Float -> Type
mod_zoom_level ui mod = {ui | zoom_level = (mod * ui.zoom_level)}
