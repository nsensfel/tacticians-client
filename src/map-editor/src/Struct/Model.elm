module Struct.Model exposing
   (
      Type,
      new,
      invalidate,
      add_tile_pattern,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet
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
      flags : Shared.Struct.Flags.Type,
      toolbox : Struct.Toolbox.Type,
      help_request : Struct.HelpRequest.Type,
      map : BattleMap.Struct.Map.Type,
      tile_patterns :
         (Dict.Dict
            Struct.TilePattern.Actual
            BattleMap.Struct.Tile.VariantID
         ),
      wild_tile_patterns : (List Struct.TilePattern.Type),
      error : (Maybe Struct.Error.Type),
      map_id : String,
      ui : Struct.UI.Type,

      map_dataset : (BattleMap.Struct.DataSet.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Shared.Struct.Flags.Type -> Type
new flags =
   let
      maybe_map_id = (Shared.Struct.Flags.maybe_get_parameter "id" flags)
      model =
         {
            flags = flags,
            toolbox = (Struct.Toolbox.default),
            help_request = Struct.HelpRequest.None,
            map = (BattleMap.Struct.Map.empty),
            tile_patterns = (Dict.empty),
            wild_tile_patterns = [],
            error = Nothing,
            map_id = "",
            ui = (Struct.UI.default),
            map_dataset = (BattleMap.Struct.DataSet.new)
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
