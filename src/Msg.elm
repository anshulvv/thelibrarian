module Msg exposing (..)

import BookSearch exposing (BookSearchResultList)
import Http


type Msg
    = RecievedSearchResults (Result Http.Error BookSearchResultList)
