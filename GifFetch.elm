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

type FetchStatus = Empty | Fetching | FetchError | Fetched

type alias Model =
  { topic : String
  , gifUrl : String
  , fetchStatus : FetchStatus
  }

init : (Model, Cmd Msg)
init = (Model "cats" "" Empty, Cmd.none)

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
      ({ model | fetchStatus = Fetching }, fetchGif model.topic)
    Response resp ->
      ({ model | gifUrl = resp, fetchStatus = Fetched }, Cmd.none)
    Error err ->
      ({ model | fetchStatus = FetchError }, Cmd.none)

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
    case model.fetchStatus of
      Empty -> div [] [text "Please click the button"]
      Fetching -> div [] [text "Fetching..."]
      Fetched -> img [src model.gifUrl] []
      FetchError -> div [] [text "Error"]
    , button [onClick Fetch] [text "Click for a new gif"]
  ]
