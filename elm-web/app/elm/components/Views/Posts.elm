module Views.Posts exposing (view)

import Html exposing (Html, a, button, div, h1, img, input, li, text, ul)
import Html.Attributes exposing (href, src, style, type_, value, target)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Post)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Views.Shared.Navbar exposing (view)


view : Model -> Html Msg
view model =
    if model.board.thread.posts == [] then
        div [] [ text "Please wait..." ]
    else
        div []
            [ Views.Shared.Navbar.view model
            , h1 [] [ text ("Posts in thread " ++ toString model.board.thread.id) ]
            , div []
                (List.map displayPosts model.board.thread.posts)
            , div []
                [ text "New Post: "
                , input [ type_ "text ", onInput PostInput, value model.messageInput ] []
                , button [ onClick SendPost ] [ text "Submit" ]
                --button [ onClick (SendMessage model.board.id model.board.thread.id) ] [ text "Submit" ]
                ]
            , a [ href (threadsPath model.board.id) ] [ text "Back to threads" ]
            ]


displayPosts : Post -> Html Msg
displayPosts post =
    div [ style [ ( "padding", "10px" ), ( "margin", "2px" ), ( "word-wrap", "break-word" ), ( "word-break", "break-all" ), ( "background-color", "lightgrey" ), ( "border", "1px solid black" ) ] ]
        [ div [] [ text ("No. #" ++ toString post.id) ]
        , if post.imagePath /= "" && post.thumbnailPath /= "" then
            div [ style [ ( "display", "table-cell" ) ]] 
                [ a [ href post.imagePath, target "_blank" ] 
                    [ img [ src post.thumbnailPath ] [] ] 
                ]
          else
            text ""
        , div [ style [ ( "display", "table-cell" ), ( "width", "100%" ), ( "vertical-align", "top" ) ] ] 
            [ text post.content ]
        ]
