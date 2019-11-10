module Page.Template exposing (templatePage)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)


templatePage : Html msg -> Html msg
templatePage pageToView =
    div
        [ id "body-div" ]
        [ viewHeader
        , viewNav
        , pageToView

        --, getServerData model
        ]


viewHeader : Html msg
viewHeader =
    header
        []
        [ h1 [] [ text "Johan Tillmar" ]
        , h3 [] [ text "An online resume and experiment in Elm" ]
        ]


viewNav : Html msg
viewNav =
    nav
        []
        [ ul
            []
            [ viewLink "Resume" "/resume"
            , viewLink "Repositories" "/repos"
            , viewLink "Home" "/home"
            ]
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
