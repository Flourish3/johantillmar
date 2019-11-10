module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Status
    = Failure
    | Loading
    | Success String


type Page
    = Home
    | Profile


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , fetchStatus : Status
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url Loading, sendReqToServer )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | SendRequest
    | GotResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "Error:" msg
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        SendRequest ->
            ( { model | fetchStatus = Loading }, sendReqToServer )

        GotResponse result ->
            -- This will always give an error for now since server has not enabled CORS
            let
                _ =
                    Debug.log "Inside response" result
            in
            case result of
                Ok url ->
                    ( { model | fetchStatus = Success url }, Cmd.none )

                Err _ ->
                    ( { model | fetchStatus = Failure }, Cmd.none )


sendReqToServer : Cmd Msg
sendReqToServer =
    Http.get
        { url = "http://127.0.0.1:8080"
        , expect = Http.expectJson GotResponse msgDecoder
        }


msgDecoder : Decoder String
msgDecoder =
    field "message" string



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Johan Tillmar"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div
        [ id "body-div" ]
        [ viewHeader
        , viewNav
        , renderMain model
        , viewResume

        --, getServerData model
        ]


viewHeader : Html Msg
viewHeader =
    header
        []
        [ h1 [] [ text "Johan Tillmar" ]
        , h3 [] [ text "An online resume and experiment in Elm" ]
        ]


viewNav : Html Msg
viewNav =
    nav
        []
        [ ul
            []
            [ viewLink "Profile" "/profile"
            , viewLink "Home" "/home"
            ]
        ]


viewResume : Html Msg
viewResume =
    div [ class "resume" ]
        [ h1 [] [ text "Resume" ]
        , viewResumeHeading "Work experience"
        , viewResumeEntry "ÅF" "2017-present" "Software Developer"
        , viewResumeEntry "Micropower" "2015/2016" "Summer intern"
        , viewResumeHeading "Education"
        ]


viewResumeHeading : String -> Html Msg
viewResumeHeading header =
    div [ class "resume-header" ]
        [ h2 [] [ text header ]
        , br [] []
        ]


viewResumeEntry : String -> String -> String -> Html Msg
viewResumeEntry header time entryText =
    div [ class "resume-entry" ]
        [ div [ class "resume-entry-header" ]
            [ h2 [ class "resume-entry-header-heading" ] [ text header ]
            , h3 [ class "resume-entry-header-time" ] [ text time ]
            ]
        , p [] [ text entryText ]
        ]


viewLink : String -> String -> Html msg
viewLink display path =
    li
        []
        [ a
            [ href path
            , class "active"
            ]
            [ text display ]
        ]


renderMain : Model -> Html msg
renderMain model =
    div []
        [ text "The current URL is this: "
        , b [] [ text (Url.toString model.url) ]
        ]


getServerData : Model -> Html Msg
getServerData model =
    case model.fetchStatus of
        Failure ->
            div []
                [ text "I could not load a random cat for some reason. "
                , button [ onClick SendRequest ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div []
                [ button [ onClick SendRequest, style "display" "block" ] [ text "More Please!" ]
                , text url
                ]
