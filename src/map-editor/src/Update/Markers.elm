module Update.Markers exposing (set_name, load, save, new, remove)

-- Elm -------------------------------------------------------------------------
import Dict
import Set

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Location
import BattleMap.Struct.Marker

-- Local Module ----------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.UI
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
set_name : (
      Struct.Model.Type ->
      String ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
set_name model name =
   (
      {model | ui = (Struct.UI.set_marker_name name model.ui)},
      Cmd.none
   )

load : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
load model =
   (
      (
         case
            (Dict.get
               (Struct.UI.get_marker_name model.ui)
               (BattleMap.Struct.Map.get_markers model.map)
            )
         of
            (Just marker) ->
               {model |
                  toolbox =
                     (Struct.Toolbox.set_selection
                        (List.map
                           (BattleMap.Struct.Location.from_ref)
                           (Set.toList
                              (BattleMap.Struct.Marker.get_locations marker)
                           )
                        )
                        model.toolbox
                     )
               }

            Nothing ->
               (Struct.Model.invalidate
                  (Struct.Error.new
                     Struct.Error.Programming
                     (
                        "Cannot load unknown marker \""
                        ++ (Struct.UI.get_marker_name model.ui)
                        ++ "\"."
                     )
                  )
                  model
               )
      ),
      Cmd.none
   )

save : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
save model =
   (
      (
         {model |
            map =
               (BattleMap.Struct.Map.set_markers
                  (Dict.insert
                     (Struct.UI.get_marker_name model.ui)
                     (BattleMap.Struct.Marker.set_locations
                        (Set.fromList
                           (List.map
                              (BattleMap.Struct.Location.get_ref)
                              (Struct.Toolbox.get_selection model.toolbox)
                           )
                        )
                        (BattleMap.Struct.Marker.new)
                     )
                     (BattleMap.Struct.Map.get_markers model.map)
                  )
                  model.map
               )
         }
      ),
      Cmd.none
   )

new : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
new model =
   (
      (
         {model |
            map =
               (BattleMap.Struct.Map.set_markers
                  (Dict.insert
                     (Struct.UI.get_marker_name model.ui)
                     (BattleMap.Struct.Marker.set_locations
                        (Set.fromList
                           (List.map
                              (BattleMap.Struct.Location.get_ref)
                              (Struct.Toolbox.get_selection model.toolbox)
                           )
                        )
                        (BattleMap.Struct.Marker.new)
                     )
                     (BattleMap.Struct.Map.get_markers model.map)
                  )
                  model.map
               )
         }
      ),
      Cmd.none
   )

remove : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
remove model =
   (
      (
         {model |
            map =
               (BattleMap.Struct.Map.set_markers
                  (Dict.remove
                     (Struct.UI.get_marker_name model.ui)
                     (BattleMap.Struct.Map.get_markers model.map)
                  )
                  model.map
               )
         }
      ),
      Cmd.none
   )

