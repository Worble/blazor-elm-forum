module Views.Threads exposing (view)

import Html exposing (Html, a, button, div, h1, input, li, text, ul)
import Html.Attributes exposing (href, type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Thread)
import Msgs exposing (Msg(..))
import Routing exposing (postsPath)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text ("Threads in board " ++ model.board.name) ]
        , ul []
            (displayThreads model)
        , input [ type_ "text ", onInput ThreadInput, value model.threadInput ] []
        , button [ onClick SendThread ] [ text "Submit" ]
        ]


displayThreads : Model -> List (Html Msg)
displayThreads model =
    List.map
        (\n ->
            case List.head n.posts of
                Just post ->
                    li [] [ a [ href (postsPath model.board.id n.id) ] [ text post.content ] ]

                Nothing ->
                    text ""
        )
        model.board.threads
