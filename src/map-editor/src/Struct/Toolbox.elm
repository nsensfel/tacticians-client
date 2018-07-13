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
      default
   )

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Location
import Struct.Map
import Struct.Tile

import Util.List

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      template : Struct.Tile.Instance,
      mode : Mode,
      shape : Shape,
      selection : (List Struct.Location.Type),
      square_corner : (Maybe Struct.Location.Type)
   }

type Mode =
   Draw
   | RemoveSelection
   | AddSelection

type Shape =
   Simple
   | Fill
   | Square

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_mode_to : (
      Struct.Location.Type ->
      (Type, Struct.Map.Type) ->
      (Type, Struct.Map.Type)
   )
apply_mode_to loc (tb, map) =
   case tb.mode of
      Draw ->
         if ((tb.selection == []) || (List.member loc tb.selection))
         then
            (
               tb,
               (Struct.Map.set_tile_to
                  loc
                  (Struct.Tile.clone_instance loc tb.template)
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

get_filled_tiles : (
      Struct.Map.Type ->
      Struct.Location.Type ->
      (List Struct.Location.Type)
   )
get_filled_tiles map loc =
   -- TODO: unimplemented
   []

get_square_tiles : (
      Struct.Location.Type ->
      Struct.Map.Type ->
      Struct.Location.Type ->
      (List Struct.Location.Type)
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
      (Util.List.product_map (Struct.Location.new) x_range y_range)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
default : Type
default =
   {
      template = (Struct.Tile.error_tile_instance 0 0 0),
      mode = Draw,
      shape = Simple,
      selection = [],
      square_corner = Nothing
   }

get_template : Type -> Struct.Tile.Instance
get_template tb = tb.template

get_mode : Type -> Mode
get_mode tb = tb.mode

get_modes : (List Mode)
get_modes =
   [
      Draw,
      AddSelection,
      RemoveSelection
   ]

get_shape : Type -> Shape
get_shape tb = tb.shape

get_shapes : (List Shape)
get_shapes =
   [
      Simple,
      Fill,
      Square
   ]

get_selection : Type -> (List Struct.Location.Type)
get_selection tb = tb.selection

set_template : Struct.Tile.Instance -> Type -> Type
set_template template tb =
   {tb |
      template = template
   }

set_mode : Mode -> Type -> Type
set_mode mode tb =
   {tb |
      mode = mode,
      square_corner = Nothing
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

is_selected : Struct.Location.Type -> Type -> Bool
is_selected loc tb =
   (List.member loc tb.selection)

is_square_corner : Struct.Location.Type -> Type -> Bool
is_square_corner loc tb =
   (tb.square_corner == (Just loc))

apply_to : (
      Struct.Location.Type ->
      Type ->
      Struct.Map.Type ->
      (Type, Struct.Map.Type)
   )
apply_to loc tb map =
   case tb.shape of
      Simple -> (apply_mode_to loc (tb, map))
      Fill ->
         (List.foldl
            (apply_mode_to)
            (tb, map)
            (get_filled_tiles map loc)
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
