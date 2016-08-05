import Counter as Counter
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.App as App


main =
  App.program {init = init, update = update, view = view, subscriptions = subscriptions}


-- MODEL

type alias Model =
  { top: Counter.Model
  , bottom: Counter.Model
  }

init : (Model, Cmd Msg)
init = (Model (Counter.init 0) (Counter.init 0), Cmd.none)


-- UPDATE

type Msg
  = Reset
  | Swap
  | Top Counter.Msg
  | Bottom Counter.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Reset ->
      (Model (Counter.init 0) (Counter.init 0), Cmd.none)
    Swap ->
      (Model model.bottom model.top, Cmd.none)
    Top msg ->
      (Model (Counter.update msg model.top) model.bottom, Cmd.none)
    Bottom msg ->
      (Model model.top (Counter.update msg model.bottom), Cmd.none)

subscriptions model = Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    div [] [
      App.map Top (Counter.view model.top)
    ],
    div [] [
      App.map Bottom (Counter.view model.bottom)
    ],
    div [] [
      button [onClick Reset] [text "Reset"]
    ],
    div [] [
      button [onClick Swap] [text "Swap"]
    ]
  ]
