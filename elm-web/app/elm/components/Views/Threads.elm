module Views.Threads exposing (view)

import Date.Extra exposing (toFormattedString)
import Element exposing (Element, button, column, el, image, layout, link, newTab, row, text, when, textLayout)
import Element.Attributes exposing (alignLeft, maxHeight, maxWidth, paddingXY, px, spacing, verticalCenter, padding, spacingXY)
import Element.Events exposing (onClick)
import Element.Input as Input
import FileReader
import Html exposing (Html, input)
import Html.Attributes exposing (accept, multiple, type_)
import Models exposing (Model, Route(..), Thread)
import Msgs exposing (Msg(..))
import Routing exposing (postsPath)
import Styles exposing (Styles(..), stylesheet)
import Views.Shared.OnLinkClick exposing (onLinkClick)


view : Model -> Element Styles variation Msg
view model =
    if model.route /= ThreadsRoute model.board.id then
        el Styles.None [] (Element.text "Please wait...")
    else
        column Styles.None
            []
            [ el Styles.Title [] (Element.text ("Threads in board " ++ model.board.name ++ ":"))
            , column Styles.None [ paddingXY 0 15, spacingXY 0 15 ] (List.map displayThread model.board.threads)
            , column Styles.None
                [ alignLeft ]
                [ row Styles.None
                    []
                    [ Input.text Styles.None
                        []
                        { onChange = PostInput
                        , value = model.messageInput
                        , label =
                            Input.placeholder
                                { label = Input.labelLeft (el None [ verticalCenter ] (text "New Thread: "))
                                , text = "Type here..."
                                }
                        , options = []
                        }
                    , button Styles.None [ onClick SendThread ] (Element.text "Submit")
                    ]
                ]
            , column Styles.None
                [ alignLeft ]
                [ Element.html
                    (Html.input
                        [ type_ "file"
                        , FileReader.onFileChange UploadFile
                        , multiple False
                        , accept "image/*"
                        ]
                        []
                    )
                , when (model.readFile /= "")
                    (image Styles.None
                        [ maxHeight (px 200), maxWidth (px 200) ]
                        { src = model.readFile, caption = "uploaded_image" }
                    )
                ]
            ]

displayThread : Thread -> Element Styles variation Msg
displayThread thread =
    column Styles.Post
        [ alignLeft, paddingXY 10 10 ]
        [ el Styles.PostHeader []
            (Element.text ("No. #" ++ toString thread.post.id ++ " made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" thread.post.createdDate))
        , textLayout Styles.None [spacing 10, paddingXY 0 10]
            [ when (thread.post.imagePath /= "")
                ( el Styles.None [ alignLeft] (newTab thread.post.imagePath <|
                    image Styles.None
                        [ maxHeight (px 200), maxWidth (px 200) ]
                        { src = thread.post.thumbnailPath, caption = "thread_image" }
                ))
            , Element.text thread.post.content
            ]
        , link (postsPath thread.boardId thread.id) <|
            el Styles.Link [ onLinkClick (ChangeLocation (postsPath thread.boardId thread.id)) ] (Element.text "View Thread")
        ]