module Views.Posts exposing (view)

import Element exposing (Element, button, column, el, image, link, row, text, when)
import Element.Attributes exposing (alignLeft, paddingXY, spacingXY, verticalCenter,padding, maxHeight, maxWidth, px)
import Element.Events exposing (onClick)
import Element.Input as Input
import FileReader
import Html exposing (Html, input)
import Html.Attributes exposing (accept, multiple, type_)
import Models exposing (Model, Post, Route(..))
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Styles exposing (Style(..), stylesheet)
import Views.Shared.OnLinkClick exposing (onLinkClick)
import Views.Shared.Post exposing (postView)


view : Model -> Element Style variation Msg
view model =
    if model.route /= PostsRoute model.board.id model.board.thread.id then
        el Styles.None [] (text "Please wait...")
    else
        column Styles.None
            []
            [ el Styles.Title [] (text ("Post in thread " ++ toString model.board.thread.id ++ ":"))
            , column Styles.None [ paddingXY 0 15, spacingXY 0 15 ] (List.map postView model.board.thread.posts)
            , column Styles.None
                [ alignLeft ]
                [ column Styles.None
                    [ spacingXY 0 10 ]
                    [ Input.multiline Styles.None
                        []
                        { onChange = PostInput
                        , value = model.messageInput
                        , label =
                            Input.placeholder
                                { label = Input.labelLeft (el None [ verticalCenter ] (text "New Post: "))
                                , text = "Type here..."
                                }
                        , options = [ Input.textKey (toString model.textHack) ]
                        }
                    , row Styles.None
                        [ spacingXY 10 0 ]
                        [ button Styles.None [ onClick SendPost, padding 10 ] (text "Submit via Http")
                        , button Styles.None [ onClick SendPostWebSocket, padding 10 ] (text "Submit via Websocket")
                        ]
                    , el Styles.None
                        []
                        (Element.html
                            (Html.input
                                [ type_ "file"
                                , FileReader.onFileChange UploadFile
                                , multiple False
                                , accept "image/*"
                                ]
                                []
                            )
                        )
                    , when (model.readFile /= "")
                        (el Styles.None
                            []
                            (image Styles.None
                                [ maxHeight (px 200), maxWidth (px 200) ]
                                { src = model.readFile, caption = "uploaded_image" }
                            )
                        )
                    ]
                , link (threadsPath model.board.id) <|
                    el Styles.Link [ onLinkClick (ChangeLocation (threadsPath model.board.id)) ] (text "Back to threads")
                ]
            ]
