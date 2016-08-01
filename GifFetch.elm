import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)
import Http
import Json.Decode as Json
import Task


main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions}


-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  }

init : (Model, Cmd Msg)
init = (Model "cats" "", Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- UPDATE

type Msg
  = Fetch
  | Response String
  | Error Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Fetch ->
      (model, fetchGif model.topic)
    Response resp ->
      ({ model | gifUrl = resp }, Cmd.none)
    Error err ->
      (model, Cmd.none)

decode : Json.Decoder String
decode =
  Json.at ["data", "image_url"] Json.string

fetchGif : String -> Cmd Msg
fetchGif topic =
  Task.perform Error Response (Http.get decode ("https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic))


-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    img [src model.gifUrl] [],
    button [onClick Fetch] [text "Click for a new gif"]
  ]
