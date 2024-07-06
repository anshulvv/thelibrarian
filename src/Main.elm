module Main exposing (..)

import BookSearch exposing (BookSearchResultList)
import Browser
import Element exposing (Element)
import Html exposing (Html)
import Http
import HttpClient
import Msg exposing (Msg)


type alias Model =
    { bookSearchResultList : Maybe BookSearchResultList
    , error : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { bookSearchResultList = Nothing
      , error = Nothing
      }
    , HttpClient.getSearchBookResults
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.RecievedSearchResults result ->
            case result of
                Ok searchResults ->
                    ( { model | bookSearchResultList = Just searchResults }, Cmd.none )

                Err error ->
                    ( { model | error = handleError error }, Cmd.none )


handleError : Http.Error -> Maybe String
handleError error =
    Just (Debug.toString error)


view : Model -> Html Msg
view model =
    Element.layout [] (viewHelper model)


viewHelper : Model -> Element Msg
viewHelper model =
    Element.column []
        [ showBookSearchResults model, Element.paragraph [] [ Element.text <| Maybe.withDefault "No Error" model.error ] ]


showBookSearchResults : Model -> Element Msg
showBookSearchResults model =
    -- Element.text <| Debug.toString model.bookSearchResultList
    let
        bookSearchResultList : BookSearchResultList
        bookSearchResultList =
            case model.bookSearchResultList of
                Just searchResults ->
                    searchResults

                Nothing ->
                    []

        -- showSingleBookInfo : BookSearchResult -> Element Msg
        -- showSingleBookInfo bookSearchInfo =
        --     Element.column []
        --         [ Element.text <| bookSearchInfo.title
        --         ]
    in
    Element.column []
        (List.map (\bookSearchResult -> Element.text bookSearchResult.title) bookSearchResultList)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
