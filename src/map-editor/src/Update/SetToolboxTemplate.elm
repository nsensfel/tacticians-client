module Update.SetToolboxTemplate exposing (apply_to)
-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Toolbox
import Struct.Tile
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model id =
   (
      {model |
         toolbox =
            (Struct.Toolbox.set_template
               (Struct.Tile.solve_tile_instance
                  (Dict.values model.tiles)
                  (Struct.Tile.error_tile_instance id 0 0)
               )
               model.toolbox
            )
      },
      Cmd.none
   )
