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
        column Styles.None
            []
            [ el Styles.Title [] (Element.text ("Threads in board " ++ model.board.name ++ ":"))
            , column Styles.None [ paddingXY 0 15, spacingXY 0 15 ] (List.map (\n -> threadView n model.board.id) model.board.threads)
            , column Styles.None
                []
                [ column Styles.None
                    [ spacingXY 0 10 ]
                    [ Input.multiline Styles.TextInput
                        []
                        { onChange = PostInput
                        , value = model.messageInput
                        , label =
                            Input.placeholder
                                { label = Input.labelLeft (el None [] (text "New Thread: "))
                                , text = "Type here..."
                                }
                        , options = [ Input.textKey (toString model.textHack) ] --this is to ensure model and view don't go out of sync
                        }
                    , row Styles.None
                        [ spacingXY 10 0 ]
                        [ button Styles.None [ onClick SendThread, paddingXY 12 10 ] (text "Submit")
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
                ]
            ]
