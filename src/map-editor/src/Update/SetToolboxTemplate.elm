module Update.SetToolboxTemplate exposing (apply_to)
-- Elm -------------------------------------------------------------------------

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
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model main_class variant_ix =
   (
      {model |
         toolbox =
            (Struct.Toolbox.set_template
               (Struct.Tile.solve_tile_instance
                  model.tiles
                  (Struct.Tile.new_instance
                     {x = 0, y = 0}
                     main_class
                     variant_ix
                     0
                     0
                     []
                  )
               )
               model.toolbox
            )
      },
      Cmd.none
   )
