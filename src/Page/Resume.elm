module Page.Resume exposing (Model, Msg, init, update, view)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Data exposing (Position, experience)
import Html exposing (..)
import Html.Attributes exposing (..)



--MODEL


type alias Model =
    Int


type Msg
    = ResumeDummy



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
        [ viewResume
        ]


viewResume : Html msg
viewResume =
    let
        experiences =
            Data.experience
    in
    div [ class "resume" ]
        (experience
            |> List.map viewPositionEntry
        )


viewPositionEntry : Position -> Html msg
viewPositionEntry pos =
    div [] [ h1 [] [ text pos.company ] ]


viewResumeEntry : String -> String -> String -> Html msg
viewResumeEntry header time entryText =
    div [ class "resume-entry" ]
        [ div [ class "resume-entry-header" ]
            [ h2 [ class "resume-entry-header-heading" ] [ text header ]
            , h3 [ class "resume-entry-header-time" ] [ text time ]
            ]
        , p [] [ text entryText ]
        ]
