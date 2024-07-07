module View exposing (..)

import BookSearch exposing (BookSearchResult, BookSearchResultList)
import Element exposing (Element, fill, height, minimum, width)
import Element.Border
import Element.Input
import Html exposing (Html)
import Model exposing (BookSearchStatus(..), Model)
import Msg exposing (Msg)


view : Model -> Html Msg
view model =
    Element.layout [] (viewHelper model)


viewHelper : Model -> Element Msg
viewHelper model =
    Element.column [ width (fill |> minimum 500) ]
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


viewSearchBookCard : BookSearchResult -> Element Msg
viewSearchBookCard bookInfo =
    let
        viewThumbnail : String -> Element Msg
        viewThumbnail url =
            Element.image
                [ height fill
                , Element.padding 20
                , Element.centerY
                ]
                { src = url
                , description = "thumbnail"
                }

        showAuthors : List String -> String
        showAuthors authors =
            case authors of
                [] ->
                    "No Authors"

                head :: tail ->
                    List.foldr (\author authorString -> authorString ++ ", " ++ author) head tail
    in
    Element.row
        [ height (fill |> minimum 100)
        , width fill
        , Element.centerY
        , Element.Border.color <| Element.rgb255 255 0 0
        , Element.Border.solid
        , Element.Border.width 3
        ]
        [ viewThumbnail bookInfo.thumbnailImageUrl
        , Element.column [ width fill, Element.spacingXY 0 20 ]
            [ Element.paragraph [] [ Element.text <| bookInfo.title ]
            , Element.text <| showAuthors bookInfo.authors
            , Element.text <| bookInfo.publishedDate
            ]
        ]


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
                viewSearchBookCard
                bookSearchResultList
            )
