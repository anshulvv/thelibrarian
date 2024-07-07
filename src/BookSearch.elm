module BookSearch exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, optionalAt, required)


type alias BookSearchResult =
    { title : String
    , authors : List String
    , pageCount : Int
    , categories : List String
    , rating : Maybe Float
    , isAdultBook : String
    , publishedDate : String
    , description : String
    , thumbnailImageUrl : String -- TODO: To be modified to Url
    , publisher : String
    }


type alias BookSearchResultList =
    List BookSearchResult


searchResultDecoder : Decoder BookSearchResultList
searchResultDecoder =
    D.succeed identity
        |> required "items" bookSearchResultListDecoder


bookSearchResultListDecoder : Decoder BookSearchResultList
bookSearchResultListDecoder =
    D.list
        (D.succeed identity
            |> required "volumeInfo" bookSearchResultDecoder
        )


bookSearchResultDecoder : Decoder BookSearchResult
bookSearchResultDecoder =
    D.succeed BookSearchResult
        |> optional "title" D.string ""
        |> optional "authors" (D.list D.string) []
        |> optional "pageCount" D.int 0
        |> optional "categories" (D.list D.string) []
        |> optional "averageRating" (D.maybe D.float) Nothing
        |> optional "maturityRating" D.string ""
        |> optional "publishedDate" D.string ""
        |> optional "description" D.string ""
        |> optionalAt [ "imageLinks", "thumbnail" ] D.string ""
        |> optional "publisher" D.string ""
