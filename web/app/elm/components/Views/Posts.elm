module Views.Posts exposing (view)

import Html exposing (Html, button, div, h1, input, li, text, ul)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Post)
import Msgs exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text ("Posts in thread " ++ toString model.board.thread.id) ]
        , ul []
            (List.map displayPosts model.board.thread.posts)
        , input [ type_ "text ", onInput PostInput, value model.messageInput ] []
        , button [ onClick SendPost ] [ text "Submit" ]
        ]


displayPosts : Post -> Html Msg
displayPosts post =
    li []
        [ text post.content
        ]
