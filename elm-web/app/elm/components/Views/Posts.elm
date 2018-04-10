module Views.Posts exposing (view)

import FileReader
import Html exposing (Html, input)
import Html.Attributes exposing (accept, multiple, type_)
import Element exposing (row, column, el, text, when, Element, image, newTab, link, textLayout, button)
import Element.Attributes exposing (paddingXY, spacingXY, alignLeft, maxHeight, maxWidth, px, verticalCenter, spacing, padding, inlineStyle)
import Element.Events exposing (onClick)
import Element.Input as Input
import Styles exposing (Styles(..), stylesheet)
import Models exposing (Model, Post, Route(..))
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Date.Extra exposing (toFormattedString)
import Views.Shared.OnLinkClick exposing (onLinkClick)


view : Model -> Element Styles variation Msg
view model =
    if model.route /= PostsRoute model.board.id model.board.thread.id then
        el Styles.None [] (Element.text "Please wait...")
    else
        column Styles.None
            []
            [ el Styles.Title [] (Element.text ("Post in thread " ++ toString model.board.thread.id ++ ":"))
            , column Styles.None [ paddingXY 0 15, spacingXY 0 15 ] (List.map displayPost model.board.thread.posts)
            , column Styles.None
                [ alignLeft ]
                [ column Styles.None
                    [ spacingXY 0 10]
                    [ Input.text Styles.None
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
                    , row Styles.None [ spacingXY 10 0 ] 
                        [ button Styles.None [ onClick SendPost, padding 10 ] (Element.text "Submit via Http")
                        , button Styles.None [ onClick SendPostWebSocket, padding 10 ] (Element.text "Submit via Websocket")
                        ]
                    , el Styles.None [] 
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
                        (el Styles.None [] 
                            ( image Styles.None
                                [ maxHeight (px 200), maxWidth (px 200) ]
                                { src = model.readFile, caption = "uploaded_image" }
                            )
                        )
                    ]
                , link (threadsPath model.board.id) <|
                    el Styles.Link [ onLinkClick (ChangeLocation (threadsPath model.board.id)) ] (Element.text "Back to threads") 
                ]
            ]

displayPost : Post -> Element Styles variation Msg
displayPost post =
    column Styles.Post
        [ alignLeft, paddingXY 10 10 ]
        [ el Styles.PostHeader []
            (Element.text ("No. #" ++ toString post.id ++ " made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" post.createdDate))
        , textLayout Styles.None [spacing 10, paddingXY 0 10]
            [ when (post.imagePath /= "")
                ( el Styles.None [ alignLeft] (newTab post.imagePath <|
                    image Styles.None
                        [ maxHeight (px 200), maxWidth (px 200) ]
                        { src = post.thumbnailPath, caption = "thread_image" }
                ))
            , Element.text post.content
            ]
        ]