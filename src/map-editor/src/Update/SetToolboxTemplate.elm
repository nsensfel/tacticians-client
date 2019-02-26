module Update.SetToolboxTemplate exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Map Editor ------------------------------------------------------------------
import Struct.Event
import Struct.Toolbox
import Struct.TileInstance
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
               (
                  case (Dict.get main_class_id model.tiles) of
                     (Just tile) -> (Struct.TileInstance.default tile)
                     _ -> (Struct.TileInstance.error 0 0)
               )
               model.toolbox
            )
      },
      Cmd.none
   )
