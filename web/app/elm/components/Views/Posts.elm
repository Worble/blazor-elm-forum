module Views.Posts exposing (view)

import Html exposing (Html, div, h1, li, text, ul, input, button)
import Html.Attributes exposing (type_)
import Html.Events exposing (onInput, onClick)
import Models exposing (Model, Post)
import Msgs exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text ("Posts in thread " ++ toString model.board.thread.id) ]
        , ul []
            (List.map displayPosts model.board.thread.posts)
        , input [ type_ "text ", onInput PostInput ] []
        , button [ onClick SendPost ] [ text "Submit" ]
        ]


displayPosts : Post -> Html Msg
displayPosts post =
    li []
        [ text post.content
        ]
