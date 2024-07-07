module Main exposing (..)

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


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = View.view
        , subscriptions = \_ -> Sub.none
        }
