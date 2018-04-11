module Views.Threads exposing (view)

import Element exposing (Element, button, column, el, image, layout, link, newTab, row, text, textLayout, when)
import Element.Attributes exposing (alignLeft, maxHeight, maxWidth, padding, paddingXY, px, spacingXY, verticalCenter)
import Element.Events exposing (onClick)
import Element.Input as Input
import FileReader
import Html exposing (Html, input)
import Html.Attributes exposing (accept, multiple, type_)
import Models exposing (Model, Route(..), Thread)
import Msgs exposing (Msg(..))
import Styles exposing (Style(..), stylesheet)
import Views.Shared.Post exposing (threadView)


view : Model -> Element Style variation Msg
view model =
    if model.route /= ThreadsRoute model.board.id then
        el Styles.None [] (Element.text "Please wait...")
    else
        column Styles.None []
            [ el Styles.Title [] (Element.text ("Threads in board " ++ model.board.name ++ ":"))
            , column Styles.None [ paddingXY 0 15, spacingXY 0 15 ] (List.map threadView model.board.threads)
            , column Styles.None
                [ alignLeft ]
                [ row Styles.None [spacingXY 10 0]
                    [ Input.text Styles.None []
                        { onChange = PostInput
                        , value = model.messageInput
                        , label =
                            Input.placeholder
                                { label = Input.labelLeft (el None [ verticalCenter ] (text "New Thread: "))
                                , text = "Type here..."
                                }
                        , options = []
                        }
                    , button Styles.None [ onClick SendThread, padding 10 ] (text "Submit")
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
                        ] []
                    )
                , when (model.readFile /= "")
                    (image Styles.None
                        [ maxHeight (px 200), maxWidth (px 200) ]
                        { src = model.readFile, caption = "uploaded_image" }
                    )
                ]
            ]