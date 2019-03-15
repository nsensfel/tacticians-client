module Struct.Model exposing
   (
      Type,
      tile_omnimods_fun,
      new,
      invalidate,
      add_tile,
      add_tile_pattern,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.Tile

-- Local Module ----------------------------------------------------------------
import Struct.Error
import Struct.HelpRequest
import Struct.TilePattern
import Struct.Toolbox
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      flags : Struct.Flags.Type,
      toolbox : Struct.Toolbox.Type,
      help_request : Struct.HelpRequest.Type,
      map : BattleMap.Struct.Map.Type,
      tile_patterns :
         (Dict.Dict
            Struct.TilePattern.Actual
            BattleMap.Struct.Tile.VariantID
         ),
      wild_tile_patterns : (List Struct.TilePattern.Type),
      tiles : (Dict.Dict BattleMap.Struct.Tile.Ref BattleMap.Struct.Tile.Type),
      error : (Maybe Struct.Error.Type),
      player_id : String,
      map_id : String,
      session_token : String,
      ui : Struct.UI.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
tile_omnimods_fun : (
      Type ->
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type)
   )
tile_omnimods_fun model =
   (\loc -> (BattleMap.Struct.Map.get_omnimods_at loc model.tiles model.map))

new : Struct.Flags.Type -> Type
new flags =
   let
      maybe_map_id = (Struct.Flags.maybe_get_param "id" flags)
      model =
         {
            flags = flags,
            toolbox = (Struct.Toolbox.default),
            help_request = Struct.HelpRequest.None,
            map = (BattleMap.Struct.Map.empty),
            tiles = (Dict.empty),
            tile_patterns = (Dict.empty),
            wild_tile_patterns = [],
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

add_tile : BattleMap.Struct.Tile.Type -> Type -> Type
add_tile tl model =
   {model |
      tiles =
         (Dict.insert
            (BattleMap.Struct.Tile.get_id tl)
            tl
            model.tiles
         )
   }

add_tile_pattern : Struct.TilePattern.Type -> Type -> Type
add_tile_pattern tp model =
   if (Struct.TilePattern.is_wild tp)
   then {model | wild_tile_patterns = (tp :: model.wild_tile_patterns)}
   else
      {model |
         tile_patterns =
            (Dict.insert
               (Struct.TilePattern.get_pattern tp)
               (Struct.TilePattern.get_variant_id tp)
               model.tile_patterns
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
