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
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model main_class border_class variant_ix =
   (
      {model |
         toolbox =
            (Struct.Toolbox.set_template
               (Struct.Tile.new_instance
                  0
                  0
                  main_class
                  border_class
                  variant_ix
                  -1
                  -1
               )
               model.toolbox
            )
      },
      Cmd.none
   )
