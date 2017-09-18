module Character exposing (Character, CharacterRef, to_comparable)

type alias Character =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      x : Int,
      y : Int
   }

type alias CharacterRef = String
to_comparable : Character -> CharacterRef
to_comparable c =
   c.id
