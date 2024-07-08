module View exposing (..)

import BookSearch exposing (BookSearchResult, BookSearchResultList)
import Element exposing (Element, fill, height, maximum, minimum, width)
import Element.Border
import Element.Font
import Element.Input
import Html exposing (Html)
import Model exposing (BookSearchStatus(..), Model)
import Msg exposing (Msg)


view : Model -> Html Msg
view model =
    Element.layout [] (viewHelper model)


viewHelper : Model -> Element Msg
viewHelper model =
    Element.column [ width (fill |> minimum 500 |> maximum 500) ]
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
                [ height (fill |> minimum 100 |> maximum 140)
                , Element.paddingEach { top = 15, bottom = 15, left = 40, right = 30 }
                , Element.centerY
                ]
                { src = url
                , description = "thumbnail"
                }
    in
    Element.row
        [ height (fill |> minimum 100)
        , width fill
        , Element.centerY
        , Element.Border.color <| Element.rgb255 200 200 200
        , Element.Border.solid
        , Element.Border.width 1
        ]
        [ viewThumbnail bookInfo.thumbnailImageUrl
        , viewBookDetailsCard bookInfo
        , viewRating bookInfo.rating
        ]


viewRating : Maybe Float -> Element Msg
viewRating maybeRating =
    case maybeRating of
        Nothing ->
            Element.none

        Just rating ->
            Element.row
                [ Element.centerY, Element.paddingXY 30 0 ]
                [ Element.paragraph [ Element.Font.size 40 ] [ Element.text <| String.fromFloat rating ]
                , Element.text <| "/5"
                ]


viewBookDetailsCard : BookSearchResult -> Element Msg
viewBookDetailsCard bookInfo =
    let
        viewTitle : String -> Element Msg
        viewTitle title =
            Element.paragraph
                [ Element.Font.bold
                , width fill
                ]
                [ Element.text <| title ]

        showAuthors : List String -> Element Msg
        showAuthors authors =
            let
                authorString =
                    case authors of
                        [] ->
                            "No Authors"

                        head :: tail ->
                            List.foldr (\author combinedAuthors -> combinedAuthors ++ ", " ++ author) head tail
            in
            Element.paragraph
                [ width fill ]
                [ Element.text <| authorString ]
    in
    Element.column
        [ width fill, Element.spacingXY 0 20 ]
        [ viewTitle bookInfo.title
        , showAuthors bookInfo.authors
        , Element.text <| bookInfo.publishedDate
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
    case model.bookSearchStatus of
        Loading ->
            viewLoader

        _ ->
            if List.isEmpty bookSearchResultList then
                Element.text <| "List is empty"

            else
                Element.column [ width fill ]
                    (List.map
                        viewSearchBookCard
                        bookSearchResultList
                    )


viewLoader : Element Msg
viewLoader =
    Element.row [ Element.centerX, Element.centerY, height (fill |> minimum 500) ]
        [ Element.image []
            { src = "https://media.tenor.com/wpSo-8CrXqUAAAAi/loading-loading-forever.gif"
            , description = "Loader"
            }
        ]
