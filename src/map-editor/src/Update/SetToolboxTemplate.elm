module Update.SetToolboxTemplate exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet
import BattleMap.Struct.TileInstance

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Toolbox
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      String ->
      String ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model main_class_id variant_id =
   (
      {model |
         toolbox =
            (Struct.Toolbox.set_template
               (BattleMap.Struct.TileInstance.default
                  (BattleMap.Struct.DataSet.get_tile
                     main_class_id
                     model.map_dataset
                  )
               )
               model.toolbox
            )
      },
      Cmd.none
   )
