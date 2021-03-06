module Struct.Toolbox exposing
   (
      Type,
      Mode(..),
      Shape(..),
      apply_to,
      is_selected,
      is_square_corner,
      clear_selection,
      set_template,
      set_mode,
      set_shape,
      get_template,
      get_mode,
      get_modes,
      get_shape,
      get_shapes,
      get_selection,
      set_selection,
      default
   )

-- Shared ----------------------------------------------------------------------
import Util.List

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.TileInstance

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      template : BattleMap.Struct.TileInstance.Type,
      mode : Mode,
      shape : Shape,
      selection : (List BattleMap.Struct.Location.Type),
      square_corner : (Maybe BattleMap.Struct.Location.Type)
   }

type Mode =
   Draw
   | RemoveSelection
   | AddSelection
   | Focus
   | Sample

type Shape =
   Simple
   | Fill
   | Square

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_mode_to : (
      BattleMap.Struct.Location.Type ->
      (Type, BattleMap.Struct.Map.Type) ->
      (Type, BattleMap.Struct.Map.Type)
   )
apply_mode_to loc (tb, map) =
   case tb.mode of
      Draw ->
         if ((tb.selection == []) || (List.member loc tb.selection))
         then
            (
               tb,
               (BattleMap.Struct.Map.set_tile_to
                  loc
                  (BattleMap.Struct.TileInstance.clone loc tb.template)
                  map
               )
            )
         else (tb, map)

      RemoveSelection ->
         (
            {tb |
               selection = (List.filter (\e -> (e /= loc)) tb.selection)
            },
            map
         )

      AddSelection ->
         (
            (
               if (List.member loc tb.selection)
               then tb
               else
                  {tb |
                     selection = (loc :: tb.selection)
                  }
            ),
            map
         )

      Focus -> (tb, map)

      Sample ->
         -- TODO: template = tile at location.
         (
            tb,
            map
         )

get_filled_tiles_internals : (
      (BattleMap.Struct.Location.Type -> Bool) ->
      (List BattleMap.Struct.Location.Type) ->
      (List BattleMap.Struct.Location.Type) ->
      (List BattleMap.Struct.Location.Type)
   )
get_filled_tiles_internals match_fun candidates result =
   case (Util.List.pop candidates) of
      Nothing -> result
      (Just (loc, remaining_candidates)) ->
         if (match_fun loc)
         then
            (get_filled_tiles_internals
               match_fun
               (
                  (List.filter
                     (\e ->
                        (not
                           (
                              (List.member e remaining_candidates)
                              || (List.member e result)
                           )
                        )
                     )
                     (BattleMap.Struct.Location.neighbors loc)
                  )
                  ++ remaining_candidates
               )
               (loc :: result)
            )
         else
            (get_filled_tiles_internals match_fun remaining_candidates result)

get_filled_tiles : (
      (List BattleMap.Struct.Location.Type) ->
      BattleMap.Struct.Map.Type ->
      BattleMap.Struct.Location.Type ->
      (List BattleMap.Struct.Location.Type)
   )
get_filled_tiles selection map loc =
   case (BattleMap.Struct.Map.try_getting_tile_at loc map) of
      Nothing -> []
      (Just target) ->
         let
            target_class_id =
               (BattleMap.Struct.TileInstance.get_class_id target)
            map_match_fun =
               (\e ->
                  (case (BattleMap.Struct.Map.try_getting_tile_at e map) of
                     Nothing -> False
                     (Just t) ->
                        (
                           (BattleMap.Struct.TileInstance.get_class_id t)
                           == target_class_id
                        )
                  )
               )
            match_fun =
               if (selection == [])
               then map_match_fun
               else (\e -> ((map_match_fun e) && (List.member e selection)))
         in
            (get_filled_tiles_internals
               match_fun
               [loc]
               []
            )

get_square_tiles : (
      BattleMap.Struct.Location.Type ->
      BattleMap.Struct.Map.Type ->
      BattleMap.Struct.Location.Type ->
      (List BattleMap.Struct.Location.Type)
   )
get_square_tiles corner map new_loc =
   let
      x_range =
         if (corner.x < new_loc.x)
         then (List.range corner.x new_loc.x)
         else (List.range new_loc.x corner.x)
      y_range =
         if (corner.y < new_loc.y)
         then (List.range corner.y new_loc.y)
         else (List.range new_loc.y corner.y)
   in
      (Util.List.product_map (BattleMap.Struct.Location.new) x_range y_range)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
default : Type
default =
   {
      template = (BattleMap.Struct.TileInstance.error 0 0),
      mode = Draw,
      shape = Simple,
      selection = [],
      square_corner = Nothing
   }

get_template : Type -> BattleMap.Struct.TileInstance.Type
get_template tb = tb.template

get_mode : Type -> Mode
get_mode tb = tb.mode

get_modes : (List Mode)
get_modes =
   [
      Draw,
      AddSelection,
      RemoveSelection,
      Focus,
      Sample
   ]

get_shape : Type -> Shape
get_shape tb = tb.shape

get_shapes : Mode -> (List Shape)
get_shapes mode =
   case mode of
      Focus -> [Simple]
      Sample -> [Simple]
      _ ->
         [
            Simple,
            Fill,
            Square
         ]

get_selection : Type -> (List BattleMap.Struct.Location.Type)
get_selection tb = tb.selection

set_selection : (List BattleMap.Struct.Location.Type) -> Type -> Type
set_selection location_list tb = {tb | selection = location_list}

set_template : BattleMap.Struct.TileInstance.Type -> Type -> Type
set_template template tb =
   {tb |
      template = template,
      mode = Draw
   }

set_mode : Mode -> Type -> Type
set_mode mode tb =
   {tb |
      mode = mode,
      square_corner = Nothing,
      shape =
         (
            if (List.member tb.shape (get_shapes mode))
            then tb.shape
            else Simple
         )
   }

set_shape : Shape -> Type -> Type
set_shape shape tb =
   {tb |
      shape = shape,
      square_corner = Nothing
   }

clear_selection : Type -> Type
clear_selection tb =
   {tb |
      selection = [],
      square_corner = Nothing
   }

is_selected : BattleMap.Struct.Location.Type -> Type -> Bool
is_selected loc tb =
   (List.member loc tb.selection)

is_square_corner : BattleMap.Struct.Location.Type -> Type -> Bool
is_square_corner loc tb =
   (tb.square_corner == (Just loc))

apply_to : (
      BattleMap.Struct.Location.Type ->
      Type ->
      BattleMap.Struct.Map.Type ->
      (Type, BattleMap.Struct.Map.Type)
   )
apply_to loc tb map =
   case tb.shape of
      Simple -> (apply_mode_to loc (tb, map))
      Fill ->
         (List.foldl
            (apply_mode_to)
            (tb, map)
            (get_filled_tiles
               (
                  if (tb.mode == Draw)
                  then tb.selection
                  else []
               )
               map
               loc
            )
         )

      Square ->
         case tb.square_corner of
            Nothing -> ({tb | square_corner = (Just loc)}, map)
            (Just corner) ->
               (List.foldl
                  (apply_mode_to)
                  ({tb | square_corner = Nothing}, map)
                  (get_square_tiles corner map loc)
               )
