module HttpClient exposing (..)

import BookSearch
import Http
import Msg exposing (Msg)


getSearchBookResults : Cmd Msg
getSearchBookResults =
    Http.get
        { url = "https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes"
        , expect = Http.expectJson Msg.RecievedSearchResults BookSearch.searchResultDecoder
        }
