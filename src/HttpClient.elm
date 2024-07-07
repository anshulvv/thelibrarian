module HttpClient exposing (..)

import BookSearch
import Http
import Msg exposing (Msg)


getSearchBookResults : String -> Cmd Msg
getSearchBookResults searchQuery =
    let
        modifiedQuery =
            String.trim searchQuery
    in
    if String.isEmpty modifiedQuery then
        Cmd.none

    else
        Http.get
            { url = "https://www.googleapis.com/books/v1/volumes?q=" ++ modifiedQuery
            , expect = Http.expectJson Msg.RecievedSearchResults BookSearch.searchResultDecoder
            }
