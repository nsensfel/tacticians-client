module Struct.Toolbox exposing
   (
      Type,
      Mode(..),
      Shape(..),
      apply_to,
      is_selected,
      clear_selection,
      set_template,
      set_mode,
      set_shape,
      get_template,
      get_mode,
      get_shape,
      get_selection,
      default
   )

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Location
import Struct.Map
import Struct.Tile

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
         (
            tb,
            (Struct.Map.set_tile_to
               loc
               (Struct.Tile.clone_instance loc tb.template)
               map
            )
         )

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
      Struct.Location.Type ->
      Struct.Map.Type ->
      (List Struct.Location.Type)
   )
get_filled_tiles loc map =
   -- TODO: unimplemented
   []

get_square_tiles : (
      Struct.Location.Type ->
      Struct.Location.Type ->
      Struct.Map.Type ->
      (List Struct.Location.Type)
   )
get_square_tiles new_loc corner map =
   -- TODO: unimplemented
   []

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
default : Type
default =
   {
      template = (Struct.Tile.error_tile_instance 0 0),
      mode = Draw,
      shape = Simple,
      selection = [],
      square_corner = Nothing
   }

get_template : Type -> Struct.Tile.Instance
get_template tb = tb.template

get_mode : Type -> Mode
get_mode tb = tb.mode

get_shape : Type -> Shape
get_shape tb = tb.shape

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

is_selected : Type -> Struct.Location.Type -> Bool
is_selected tb loc =
   (List.member loc tb.selection)

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
            (get_filled_tiles loc map)
         )

      Square ->
         case tb.square_corner of
            Nothing -> ({tb | square_corner = (Just loc)}, map)
            (Just corner) ->
               (List.foldl
                  (apply_mode_to)
                  (tb, map)
                  (get_square_tiles loc corner map)
               )
