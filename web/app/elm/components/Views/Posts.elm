module Views.Posts exposing (view)

import Html exposing (Html, div, h1, li, text, ul)
import Models exposing (Model, Post)
import Msgs exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text ("Posts in thread " ++ toString model.board.thread.id) ]
        , ul []
            (List.map displayPosts model.board.thread.posts)
        ]


displayPosts : Post -> Html Msg
displayPosts post =
    li []
        [ text post.content
        ]
