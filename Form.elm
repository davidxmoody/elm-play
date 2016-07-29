import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Char exposing (isDigit)
import Result exposing (withDefault)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , age : Int
  , password : String
  , passwordAgain : String
  , submitted : Bool
  }


model : Model
model =
  Model "" 0 "" "" False


-- UPDATE

type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Submit


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = withDefault 0 (String.toInt age) }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Submit ->
      { model | submitted = True }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "number", placeholder "Age", onInput Age ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick Submit ] [ text "Submit" ]
    , viewValidation model
    , text <| "You are " ++ (toString model.age) ++ " years old!"
    ]
    
mixedCase : String -> Bool
mixedCase str = (str /= String.toLower str) && (str /= String.toUpper str)

containsNumber : String -> Bool
containsNumber = String.any isDigit

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if not model.submitted then
         ("transparent", "")
      else if (String.length model.password) < 8 then
         ("red", "Not long enough")
      else if not <| mixedCase model.password then
         ("red", "Must contain upper and lower case characters")
      else if not <| containsNumber model.password then
         ("red", "Must contain a number")
      else if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
      else
        ("green", "OK")
  in
    div [ style [("color", color)] ] [ text message ]
