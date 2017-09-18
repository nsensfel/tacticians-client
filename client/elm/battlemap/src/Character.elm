module Character exposing (Character, CharacterRef, to_comparable)

import Battlemap.Location exposing (Location)

type alias Character =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      location : Location
   }

type alias CharacterRef = String
to_comparable : Character -> CharacterRef
to_comparable c =
   c.id
