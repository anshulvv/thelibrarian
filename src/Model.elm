module Model exposing (..)

import BookSearch exposing (BookSearchResultList)


type BookSearchStatus
    = Loading
    | Loaded BookSearchResultList
    | NoOp


type alias Model =
    { bookSearchStatus : BookSearchStatus
    , error : Maybe String
    , searchInput : Maybe String
    }
