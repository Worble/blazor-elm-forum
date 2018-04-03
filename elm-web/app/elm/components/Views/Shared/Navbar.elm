module Views.Shared.Navbar exposing (view)

import Html exposing (Html, a, div, h3, span, text)
import Html.Attributes exposing (href)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)


view : Model -> Html Msg
view model =
    div []
        [ span [] [ text "Boards: " ]
        , span []
            (List.map displayBoards model.boards)
        ]


displayBoards : Board -> Html Msg
displayBoards board =
    span [] 
    [ a [ href (threadsPath board.id) ] [ text board.name ]
    , text " | " ]
