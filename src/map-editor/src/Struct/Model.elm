module Struct.Model exposing
   (
      Type,
      new,
      invalidate,
      add_tile,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

-- Map -------------------------------------------------------------------
import Struct.Error
import Struct.Flags
import Struct.HelpRequest
import Struct.Map
import Struct.Tile
import Struct.TilePattern
import Struct.Toolbox
import Struct.UI

import Util.Array

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      toolbox: Struct.Toolbox.Type,
      help_request: Struct.HelpRequest.Type,
      map: Struct.Map.Type,
      tile_patterns: (List Struct.TilePattern.Type),
      tiles: (Dict.Dict Struct.Tile.Ref Struct.Tile.Type),
      error: (Maybe Struct.Error.Type),
      player_id: String,
      map_id: String,
      session_token: String,
      ui: Struct.UI.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Struct.Flags.Type -> Type
new flags =
   let
      maybe_map_id = (Struct.Flags.maybe_get_param "id" flags)
      model =
         {
            toolbox = (Struct.Toolbox.default),
            help_request = Struct.HelpRequest.None,
            map = (Struct.Map.empty),
            tiles = (Dict.empty),
            tile_patterns = [],
            error = Nothing,
            map_id = "",
            player_id =
               (
                  if (flags.user_id == "")
                  then "0"
                  else flags.user_id
               ),
            session_token = flags.token,
            ui = (Struct.UI.default)
         }
   in
      case maybe_map_id of
         Nothing ->
            (invalidate
               (Struct.Error.new
                  Struct.Error.Failure
                  "Could not find map id."
               )
               model
            )

         (Just id) -> {model | map_id = id}

add_tile : Struct.Tile.Type -> Type -> Type
add_tile tl model =
   {model |
      tiles =
         (Dict.insert
            (Struct.Tile.get_id tl)
            tl
            model.tiles
         )
   }

reset : Type -> Type
reset model =
   {model |
      toolbox = (Struct.Toolbox.default),
      help_request = Struct.HelpRequest.None,
      error = Nothing,
      ui = (Struct.UI.set_previous_action Nothing model.ui)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
