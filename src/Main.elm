module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Page.Home as Home
import Page.Repos as Repos
import Page.Resume as Resume
import Page.Template exposing (templatePage)
import Route exposing (Route)
import Url exposing (Url)



-- MODEL


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | HomePage Home.Model
    | ReposPage Repos.Model
    | ResumPage Resume.Model


type Msg
    = HomeMsg Home.Msg
    | ReposMsg Repos.Msg
    | ResumeMsg Resume.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url



-- INIT


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Home ->
                    let
                        ( pageModel, pageCmds ) =
                            Home.init
                    in
                    ( HomePage pageModel, Cmd.map HomeMsg pageCmds )

                Route.Repos ->
                    let
                        ( pageModel, pageCmds ) =
                            Repos.init
                    in
                    ( ReposPage pageModel, Cmd.map ReposMsg pageCmds )

                Route.Resume ->
                    let
                        ( pageModel, pageCmds ) =
                            Resume.init
                    in
                    ( ResumPage pageModel, Cmd.map ResumeMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Johan Tillmar"
    , body = [ currentView model ]
    }


currentView : Model -> Html Msg
currentView model =
    templatePage <| viewFromModel model


viewFromModel : Model -> Html Msg
viewFromModel model =
    case model.page of
        NotFoundPage ->
            notFoundView

        HomePage pageModel ->
            Home.view pageModel
                |> Html.map HomeMsg

        ReposPage pageModel ->
            Repos.view pageModel
                |> Html.map ReposMsg

        ResumPage pageModel ->
            Resume.view pageModel
                |> Html.map ResumeMsg


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( HomeMsg subMsg, HomePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Home.update subMsg pageModel
            in
            ( { model | page = HomePage updatedPageModel }
            , Cmd.map HomeMsg updatedCmd
            )

        ( ReposMsg subMsg, ReposPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Repos.update subMsg pageModel
            in
            ( { model | page = ReposPage updatedPageModel }
            , Cmd.map ReposMsg updatedCmd
            )

        ( ResumeMsg subMsg, ResumPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Resume.update subMsg pageModel
            in
            ( { model | page = ResumPage updatedPageModel }
            , Cmd.map ResumeMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( _, _ ) ->
            ( model, Cmd.none )



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
