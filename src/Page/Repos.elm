module Page.Repos exposing (Model, Msg, init, update, view)

import Html exposing (..)



--MODEL


type alias Model =
    Int


type Msg
    = RepoDummy



-- INIT


init : ( Model, Cmd Msg )
init =
    ( 1, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Repos" ]
        ]
