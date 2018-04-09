module Views.Posts exposing (view)

import FileReader
import Html exposing (Html, a, br, button, div, h1, img, input, li, text, ul)
import Html.Attributes exposing (accept, href, multiple, src, style, target, type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Post, Route(..))
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Date.Extra exposing (toFormattedString)
import Views.Shared.OnLinkClick exposing (onLinkClick)


view : Model -> Html Msg
view model =
    if model.route /= PostsRoute model.board.id model.board.thread.id then
        div [] [ text "Please wait..." ]
    else
        div []
            [ if model.board.thread.archived then
                div
                    [ style
                        [ ( "background-color", "blanchedalmond" )
                        , ( "min-height", "50px" )
                        , ( "text-align", "center" )
                        , ( "font-size", "24px" )
                        ]
                    ]
                    [ text "Thread Archived: Posting is disabled" ]
                else
                    text ""
            , h1 []
                [ text ("Posts in thread " ++ toString model.board.thread.id)
                ]
            , div []
                (List.map displayPosts model.board.thread.posts)
            , div []
                [ text "New Post: "
                , input [ type_ "text ", onInput PostInput, value model.messageInput ]
                    []
                , button [ onClick SendPost ] [ text "Submit via Http" ]
                , button [ onClick SendPostWebSocket ] [ text "Submit via WebSocket" ]
                , div []
                    [ input
                        [ type_ "file"
                        , FileReader.onFileChange UploadFile
                        , multiple False
                        , accept "image/*"
                        ]
                        []
                    ]
                , if model.readFile /= "" then
                    div []
                        [ img
                            [ src model.readFile
                            , style
                                [ ( "max-height", "200px" )
                                , ( "max-width", "200px" )
                                ]
                            ]
                            []
                        ]
                  else
                    text ""

                --button [ onClick (SendMessage model.board.id model.board.thread.id) ] [ text "Submit" ]
                ]
            , br [] []
            , a 
                [ href (threadsPath model.board.id)
                , onLinkClick (ChangeLocation (threadsPath model.board.id)) 
                ] 
                [ text "Back to threads" 
                ]
            ]


displayPosts : Post -> Html Msg
displayPosts post =
    div
        [ style
            [ ( "padding", "10px" )
            , ( "margin", "2px" )
            , ( "word-wrap", "break-word" )
            , ( "word-break", "break-all" )
            , ( "background-color", "lightgrey" )
            , ( "border", "1px solid black" )
            ]
        ]
        [ div
            [ style
                [ ( "border-bottom", "solid black 1px" )
                ]
            ]
            [ text ("No. #" ++ toString post.id ++ " made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" post.createdDate)
            ]
        , if post.imagePath /= "" && post.thumbnailPath /= "" then
            div
                [ style
                    [ ( "display", "table-cell" )
                    ]
                ]
                [ a
                    [ href post.image 
                    , target "_blank"
                    ]
                    [ img
                        [ src post.thumbnailPath ]
                        []
                    ]
                ]
          else
            text ""
        , div 
            [ style 
                [ ( "display", "table-cell" )
                , ( "width", "100%" )
                , ( "vertical-align", "top" ) 
                ] 
            ]
            [ text post.content 
            ]
        ]
