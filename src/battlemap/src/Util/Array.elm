module Util.Array exposing (update, update_unsafe)

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
