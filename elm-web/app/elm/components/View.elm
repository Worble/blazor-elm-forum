module View exposing (view)

import Html exposing (Html, div, li, text, ul)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Views.Boards
import Views.Posts
import Views.Threads


view : Model -> Html Msg
view model =
    div []
        [ case model.route of
            Models.BoardsRoute ->
                Views.Boards.view model

            Models.ThreadsRoute threadId ->
                Views.Threads.view model

            Models.PostsRoute threadId postId ->
                Views.Posts.view model

            Models.NotFoundRoute ->
                div []
                    [ text ("404 - Not Found: " ++ model.text) ]
        ]
