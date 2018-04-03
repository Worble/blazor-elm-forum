module Views.Posts exposing (view)

import Html exposing (Html, button, div, h1, input, li, text, ul)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Post)
import Msgs exposing (Msg(..))
import Views.Shared.Navbar exposing (view)


view : Model -> Html Msg
view model =
    div []
        [ Views.Shared.Navbar.view model
        , h1 [] [ text ("Posts in thread " ++ toString model.board.thread.id) ]
        , ul []
            (List.map displayPosts model.board.thread.posts)
        , text "New Post: "
        , input [ type_ "text ", onInput PostInput, value model.messageInput ] []
        , button [ onClick (SendMessage model.board.id model.board.thread.id) ] [ text "Submit" ]
        ]


displayPosts : Post -> Html Msg
displayPosts post =
    li []
        [ text post.content
        ]
