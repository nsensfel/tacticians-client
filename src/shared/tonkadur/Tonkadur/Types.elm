module Tonkadur.Wyrd exposing (..)

-- Elm -------------------------------------------------------------------------
import Dict
import List

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias TextData =
   {
      content : (List.List RichText),
      effect_name : String,
      effect_parameters : (List.List Value)
   }

type RichText =
   StringText String
   | AugmentedText TextData
   | Newline

type Value =
   BoolValue Bool
   | FloatValue Float
   | IntValue Int
   | TextValue RichText
   | StringValue String
   | ListValue (Dict.Dict String Value)
   | PointerValue (List.List String)
   | StructureValue (Dict.Dict String Value)

type Option =
   Choice RichText
   | Event (String, (List.List Value))

type Computation =
   AddTextEffect (String, (List.List Computation), (List.List Computation))
   | Address Computation
   | Cast (String, String, Computation)
   | Constant (String, String)
   | ExtraComputation (String, (List.List Computation))
   | IfElse (Computation, Computation, Computation)
   | LastChoiceIndex
   | Newline
   | NextAllocableAddress
   | Operation (String, Computation, Computation)
   | RelativeAddress (Computation, Computation)
   | Size Computation
   | Text (List.List Computation)
   | ValueOf Computation

type Instruction =
   AddEventOption (String, (List.List Computation))
   | AddTextOption Computation
   | Assert (Computation, Computation)
   | Display Computation
   | End
   | ExtraInstruction (String, (List.List Computation))
   | Initialize (String, Computation)
   | PromptCommand (Computation, Computation, Computation, Computation)
   | PromptInteger (Computation, Computation, Computation, Computation)
   | PromptString (Computation, Computation, Computation, Computation)
   | Remove Computation
   | ResolveChoice
   | SetPC Computation
   | SetRandom (Computation, Computation, Computation)
   | Set (Computation, Computation)

type InstructionEffect =
   Continue
   | End
   | PromptCommand (Value, Value, Value)
   | PromptInteger (Value, Value, Value)
   | PromptString (Value, Value, Value)
   | PromptChoice
   | Display Value
   | DisplayError Value
   | ExtraEffect (String, (List.List Value))

type alias State =
   {
      memory : (Dict.Dict String Value)
      user_types : (Dict.Dict String Value),
      sequences : (Dict.Dict String Int),
      code : (List.List Instruction),
      program_counter : Int,
      allocated_data : Int,
      last_choice_index : Int,
      available_options : (List.List Option),
      memorized_target : Value
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
value_to_bool : Value -> Bool
value_to_bool value =
   case value of
      (BoolValue result) -> result
      _ -> False

value_to_float : Value -> Float
value_to_float value =
   case value of
      (FloatValue result) -> result
      _ -> 0.0

value_to_int : Value -> Int
value_to_int value =
   case value of
      (IntValue result) -> result
      _ -> 0

value_to_text_or_string : Value -> RichText
value_to_text_or_string value =
   case value of
      (TextValue result) -> result
      (StringValue string) -> (StringText string)
      _ -> (StringText "")

value_to_string : Value -> String
value_to_string value =
   case value of
      (StringValue result) -> result
      (TextValue text) ->
         case text of
            (StringText result) -> result
            (AugmentedText rich_text) ->
               (String.concat
                  (List.map (value_to_string) rich_text.content)
               )

            Newline -> "\n"

      _ -> (StringText "")

value_to_dict : Value -> (Dict.Dict String Value)
value_to_dict value =
   case value of
      (StructureValue dict) -> dict
      (ListValue dict) -> dict
      _ -> (Dict.empty)

value_to_address : Value -> (List.List String)
value_to_address value =
   case value of
      (PointerValue result) -> result
      _ -> (List.empty)

no_text_effect : String
no_text_effect = ""

type RichText =
   StringText String
   | AugmentedText TextData
   | Newline

append_text_content : RichText -> RichText -> RichText
append_text_content base addition =
   case base of
      (AugmentedText text_data) ->
         case addition of
            (AugmentedText other_text_data) ->
               -- Optimize text to avoid increasing depth if no new effect is
               -- introduced.
               if (other_text_data.effect_name == (no_text_effect))
               then
                  {base |
                     content =
                        (List.append base.content other_text_data.content)
                  }
               else
                  {base |
                     content =
                        (List.append
                           base.content
                           (List.singleton other_text_data)
                        )
                  }

            other ->
               {base |
                  content =
                     (List.append base.content (List.singleton other_text_data))
               }

      non_augmented_text_data ->
         (append_text_content
            (append_text_content (AugmentedText (default_text_data)) base)
            addition
         )

default_text_data : TextData
default_text_data =
   {
      effect_name = (no_text_effect),
      effect_parameters = (List.empty),
      content = (List.empty)
   }

append_option : Option -> State -> State
append_option option state =
   {state |
      available_options =
         (List.append state.available_options (List.singleton option))
   }

get_default : State -> String -> Value
get_default state type_name =
   case type_name of
      "bool" -> (BoolValue False)
      "float" -> (FloatValue 0.0)
      "int" -> (IntValue 0)
      "text" -> (TextValue (StringText ""))
      "string" -> (StringValue "")
      "list" -> (ListValue (Dict.empty))
      "ptr" -> (PointerValue (List.empty))
      other ->
         case (Dict.get other state.user_types) of
            (Just default) -> default
            Nothing -> (StringValue ("Unknown type '" + other + "'"))
