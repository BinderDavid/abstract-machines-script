module Main exposing (..)
import Browser
import Debug exposing (todo)
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)
import AE as AE

-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = { inputString : String }

init : Model
init = { inputString = "" }


-- UPDATE

type Msg = TextChange String

update : Msg -> Model -> Model
update msg model =
  case msg of
    TextChange str ->
         { model | inputString = str }

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Enter arithmetic expression...", value model.inputString, onInput TextChange ] [ text "-" ]
    , viewHelper model.inputString
    ]

viewHelper : String -> Html Msg
viewHelper str = div [] [ text (case AE.parse str of
                                   Ok res -> AE.showTerm res
                                   Err err -> "Parsing error")]