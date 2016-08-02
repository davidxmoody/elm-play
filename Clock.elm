import Html exposing (div, button, Html, text)
import Html.Events exposing (onClick)
import Html.App as App
import Svg exposing (svg, circle, line)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { time : Time
  , running : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model 0 True, Cmd.none)


-- UPDATE

type Msg
  = Tick Time
  | Toggle


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = newTime}, Cmd.none)
    Toggle ->
      ({ model | running = not model.running }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.running then Time.every second Tick else Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model.time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    div [] [
      svg [ viewBox "0 0 100 100", width "300px" ]
        [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
        , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
        ]
      , button [onClick Toggle] [text "Toggle clock"]
    ]
