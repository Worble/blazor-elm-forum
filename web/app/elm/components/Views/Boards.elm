module Views.Boards exposing (view)

import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Models exposing (Board)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)


view : List Board -> Html Msg
view boards =
    div []
        [ h1 [] [ text "Boards" ]
        , ul []
            (List.map displayBoards boards)
        ]


displayBoards : Board -> Html Msg
displayBoards board =
    li []
        [ a [ href (threadsPath board.id) ] [ text board.name ] ]
