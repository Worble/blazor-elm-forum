module Views.Boards exposing (view)

import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)


view : Model -> Html Msg
view model =
    if model.boards == [] then
        div [] [ text "Please wait..." ]
    else
        div []
            [ h1 [] [ text "Boards" ]
            , ul []
                (List.map displayBoards model.boards)
            ]


displayBoards : Board -> Html Msg
displayBoards board =
    li []
        [ a [ href (threadsPath board.id) ] [ text board.name ] ]
