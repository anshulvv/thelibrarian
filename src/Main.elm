module Main exposing (..)

import BookSearch exposing (BookSearchResultList)
import Browser
import Http
import HttpClient
import Model exposing (BookSearchStatus(..), Model)
import Msg exposing (Msg)
import View


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
            let
                bookSearchStatus =
                    if String.isEmpty (String.trim newSearchInput) then
                        NoOp

                    else
                        Loading
            in
            ( { model
                | searchInput = Just newSearchInput
                , bookSearchStatus = bookSearchStatus
              }
            , HttpClient.getSearchBookResults newSearchInput
            )

        Msg.OnImageLoad bookId ->
            case model.bookSearchStatus of
                Loaded bookSearchResultList ->
                    ( { model | bookSearchStatus = Loaded (changeImageLoadStatusToLoaded bookId bookSearchResultList) }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )


changeImageLoadStatusToLoaded : String -> BookSearchResultList -> BookSearchResultList
changeImageLoadStatusToLoaded bookId bookSearchResultList =
    List.map
        (\bookSearchResult ->
            if bookSearchResult.id == bookId then
                { bookSearchResult | imageLoadStatus = BookSearch.ImageLoaded }

            else
                bookSearchResult
        )
        bookSearchResultList


handleError : Http.Error -> Maybe String
handleError error =
    Just (Debug.toString error)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = View.view
        , subscriptions = \_ -> Sub.none
        }
