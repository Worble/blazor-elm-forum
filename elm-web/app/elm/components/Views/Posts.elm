module Views.Posts exposing (view)

import Element exposing (Element, button, column, el, image, link, paragraph, row, text, when)
import Element.Attributes exposing (alignLeft, center, id, maxHeight, maxWidth, padding, paddingXY, percent, px, spacingXY, verticalCenter, width, height)
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
    if model.route /= PostsRoute model.board.shorthandName model.board.thread.opPost.id then
        el Styles.None [] (text "Please wait...")
    else
        column Styles.None
            []
            [ el Styles.Title [] (text ("Post in thread " ++ toString model.board.thread.id ++ ":"))
            , when model.board.thread.archived
                (row Styles.Error
                    [ width (percent 100), center, onClick RemoveError ]
                    [ paragraph Styles.None
                        [ padding 20 ]
                        [ text "Thread is archived: posting is disabled" ]
                    ]
                )
            , column Styles.None [ paddingXY 0 15, spacingXY 0 15 ] (List.map (\n -> postView n model.board.shorthandName model.board.thread.opPost.id) model.board.thread.posts)
            , column Styles.None
                []
                [ column Styles.None
                    [ spacingXY 0 10 ]
                    [ Input.multiline Styles.TextInput
                        [ id "input", height (px 100) ]
                        { onChange = PostInput
                        , value = model.messageInput
                        , label =
                            Input.placeholder
                                { label = Input.labelLeft (el None [] (text "New Post: "))
                                , text = "Type here..."
                                }
                        , options = [ Input.textKey (toString model.textHack) ] --this is to ensure model and view don't go out of sync
                        }
                    , row Styles.None
                        [ spacingXY 10 0 ]
                        [ button Styles.None [ onClick SendPost, paddingXY 12 10 ] (text "Submit via Http")
                        , button Styles.None [ onClick SendPostWebSocket, paddingXY 12 10 ] (text "Submit via Websocket")
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
                , el Styles.None
                    [ alignLeft ]
                    (link (threadsPath model.board.shorthandName) <|
                        el Styles.Link [ onLinkClick (ChangeLocation (threadsPath model.board.shorthandName)) ] (text "Back to threads")
                    )
                ]
            ]
