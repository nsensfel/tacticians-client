module Util.Array exposing (update)

import Array

update : (
      Int ->
      ((Maybe t) -> (Maybe t)) ->
      (Array t) ->
      (Array t)
   )
update index fun array =
   case (fun (Array.get index array)) of
      Nothing -> array
      (Just e) -> (Array.set index e array)
