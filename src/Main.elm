module Main exposing (..)

import BookSearch exposing (BookSearchResultList)
import Browser
import Element exposing (Element)
import Element.Input
import Html exposing (Html)
import Http
import HttpClient
import Maybe
import Msg exposing (Msg)


type BookSearchStatus
    = Loading
    | Loaded BookSearchResultList
    | Error Http.Error
    | NoOp


type alias Model =
    { bookSearchStatus : BookSearchStatus
    , error : Maybe String
    , searchInput : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { bookSearchStatus = NoOp
      , error = Nothing
      , searchInput = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.RecievedSearchResults result ->
            case result of
                Ok searchResults ->
                    ( { model | bookSearchStatus = Loaded searchResults }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | error = handleError error }
                    , Cmd.none
                    )

        Msg.SearchInputChanged newSearchInput ->
            if String.isEmpty newSearchInput then
                ( { model
                    | searchInput = Nothing
                    , bookSearchStatus = NoOp
                  }
                , Cmd.none
                )

            else
                ( { model
                    | searchInput = Just newSearchInput
                    , bookSearchStatus = Loading
                  }
                , HttpClient.getSearchBookResults newSearchInput
                )


handleError : Http.Error -> Maybe String
handleError error =
    Just (Debug.toString error)


view : Model -> Html Msg
view model =
    Element.layout [] (viewHelper model)


viewHelper : Model -> Element Msg
viewHelper model =
    Element.column []
        [ viewSearchBox model
        , viewBookSearchResults model
        , Element.paragraph [] [ Element.text <| Maybe.withDefault "No Error" model.error ]
        ]


viewSearchBox : Model -> Element Msg
viewSearchBox model =
    Element.Input.search
        []
        { onChange = Msg.SearchInputChanged
        , text = model.searchInput |> Maybe.withDefault ""
        , placeholder = Just (Element.Input.placeholder [] (Element.text "Search Here"))
        , label = Element.Input.labelHidden "something"
        }


viewBookSearchResults : Model -> Element Msg
viewBookSearchResults model =
    let
        bookSearchResultList : BookSearchResultList
        bookSearchResultList =
            case model.bookSearchStatus of
                Loaded searchResults ->
                    searchResults

                _ ->
                    []
    in
    if List.isEmpty bookSearchResultList then
        Element.text <| "List is empty"

    else
        Element.column []
            (List.map
                (\bookSearchResult -> Element.text bookSearchResult.title)
                bookSearchResultList
            )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
