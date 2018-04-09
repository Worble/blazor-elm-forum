module Views.Threads exposing (view)

import Date.Extra exposing (toFormattedString)
import FileReader
import Html exposing (Html, a, button, div, h1, img, input, li, text, ul)
import Html.Attributes exposing (accept, href, multiple, src, style, target, type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Thread, Route(..))
import Msgs exposing (Msg(..))
import Routing exposing (postsPath)
import Views.Shared.Navbar exposing (view)
import Views.Shared.OnLinkClick exposing (onLinkClick)


view : Model -> Html Msg
view model =
    if model.route /= ThreadsRoute model.board.id then
        div [] [ text "Please wait..." ]
    else
        div []
            [ h1 [] [ text ("Threads in board " ++ model.board.name) ]
            , div [] (displayThreads model.board.threads)
            , div []
                [ text "New Thread: "
                , input [ type_ "text ", onInput PostInput, value model.messageInput ] []
                , button [ onClick SendThread ] [ text "Submit" ]
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
                ]
            ]


displayThreads : List Thread -> List (Html Msg)
displayThreads threadList =
    List.map
        (\t ->
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
                    [ text ("No. #" ++ toString t.post.id ++ " made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" t.post.createdDate) ]
                , div
                    [ style [ ( "display", "table" ), ( "min-height", "50px" ), ( "width", "100%" ) ]
                    ]
                    [ if t.post.thumbnailPath /= "" && t.post.imagePath /= "" then
                        div
                            [ style
                                [ ( "display", "table-cell" )
                                ]
                            ]
                            [ a
                                [ href t.post.imagePath, target "_blank" ]
                                [ img
                                    [ src t.post.thumbnailPath
                                    , style
                                        [ ( "max-height", "100px" )
                                        , ( "max-width", "100px" )
                                        ]
                                    ]
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
                        [ text t.post.content ]
                    ]
                , a
                    [ href (postsPath t.boardId t.id)
                    , onLinkClick (ChangeLocation (postsPath t.boardId t.id))
                    ]
                    [ text "View Thread" ]
                ]
        )
        threadList
