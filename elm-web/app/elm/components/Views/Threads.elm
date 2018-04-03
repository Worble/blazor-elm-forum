module Views.Threads exposing (view)

import Html exposing (Html, a, button, div, h1, img, input, li, text, ul)
import Html.Attributes exposing (href, src, style, target, type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model, Thread)
import Msgs exposing (Msg(..))
import Routing exposing (postsPath)
import Views.Shared.Navbar exposing (view)


view : Model -> Html Msg
view model =
    if model.board.threads == [] then
        div [] [ text "Please wait..." ]
    else
        div []
            [ Views.Shared.Navbar.view model
            , h1 [] [ text ("Threads in board " ++ model.board.name) ]
            , div [] (displayThreads model.board.threads)
            , div [] 
                [ text "New Thread: "
                , input [ type_ "text ", onInput ThreadInput, value model.threadInput ] []
                , button [ onClick SendThread ] [ text "Submit" ]
                ]
            ]


displayThreads : List Thread -> List (Html Msg)
displayThreads threadList =
    List.map
        (\t ->
            div [ style [ ( "padding", "10px" ), ( "margin", "2px" ), ( "word-wrap", "break-word" ), ( "word-break", "break-all" ), ( "background-color", "lightgrey" ), ( "border", "1px solid black" ) ] ]
                [ div [] [ text ("No. #" ++ toString t.post.id) ]
                , div [ style[("display","table"), ("min-height","50px"), ("width","100%")]]
                    [ if t.post.thumbnailPath /= "" && t.post.imagePath /= "" then
                        div [style[("display","table-cell")]] 
                            [ a [ href t.post.imagePath, target "_blank" ] 
                                [ img [ src t.post.thumbnailPath, style[("max-height","100px"), ("max-width","100px")] ] [] ] 
                            ]
                      else
                        text ""
                    , div [style[("display","table-cell"), ("width","100%"), ("vertical-align","top")]] 
                        [ text t.post.content ]
                    ]
                , a [ href (postsPath t.boardId t.id) ] [ text "View Thread" ]
                ]
        )
        threadList
