import Html exposing (..) 
import Html.App as Html
import Html.Events exposing (onClick)
import Random


main =
  Html.program { init = init, update = update, view = view, subscriptions = subscriptions }


-- MODEL

type alias Model =
  { dieFaces: (Int, Int)
  }

model : Model
model = 
  { dieFaces = (1, 1)
  }

init : (Model, Cmd Msg)
init = (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- UPDATE

type Msg
  = Roll
  | UpdateFace (Int, Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate UpdateFace (Random.pair (Random.int 1 6) (Random.int 1 6)))
    UpdateFace pair ->
      (Model pair, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    span [] [ text (toString (fst model.dieFaces))],
    span [] [ text (toString (snd model.dieFaces))],
    button [ onClick Roll ] [ text "Roll!" ]
  ]
