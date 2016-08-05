module Counter exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
  { count : Int
  , max : Int
  , min : Int
  }


init : Int -> Model
init count =
  { count = count
  , max = count
  , min = count
  }



-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | count = model.count + 1, max = Basics.max model.max (model.count + 1) }

    Decrement ->
      { model | count = model.count - 1, min = Basics.min model.min (model.count - 1) }



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]


countStyle : Attribute msg
countStyle =
  style
    [ ("font-size", "18px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "500px")
    , ("text-align", "center")
    ]
