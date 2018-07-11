module Util.Array exposing
   (
      update,
      update_unsafe,
      filter_first
   )

import Array

update : (
      Int ->
      ((Maybe t) -> (Maybe t)) ->
      (Array.Array t) ->
      (Array.Array t)
   )
update index fun array =
   case (fun (Array.get index array)) of
      Nothing -> array
      (Just e) -> (Array.set index e array)

update_unsafe : (
      Int ->
      (t -> t) ->
      (Array.Array t) ->
      (Array.Array t)
   )
update_unsafe index fun array =
   case (Array.get index array) of
      Nothing -> array
      (Just e) -> (Array.set index (fun e) array)

filter_first : (t -> Bool) -> (Array.Array t) -> (Maybe t)
filter_first fun array =
   (Array.get 0 (Array.filter fun array))
