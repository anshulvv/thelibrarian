module HttpClient exposing (..)

import BookSearch
import Http
import Msg exposing (Msg)


getSearchBookResults : String -> Cmd Msg
getSearchBookResults searchQuery =
    Http.get
        { url = "https://www.googleapis.com/books/v1/volumes?q=" ++ searchQuery
        , expect = Http.expectJson Msg.RecievedSearchResults BookSearch.searchResultDecoder
        }
