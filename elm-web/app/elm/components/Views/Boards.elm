module Views.Boards exposing (view)

import Element exposing (column, el, row, text, Element, link, layout)
import Element.Attributes exposing (padding, spacing)
import Html exposing (Html)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Styles exposing (Style(..), stylesheet)
import Views.Shared.OnLinkClick exposing (onLinkClick)


view : Model -> Element Style variation Msg
view model =
    if model.boards == [] then
        el Styles.None [] (text "Please wait...")
    else
        column None
            []
            [ el Styles.Title [] (text "Boards:")
            , row None [ padding 10, spacing 7 ] (List.map displayBoards model.boards)
            ]


displayBoards : Board -> Element Style variation Msg
displayBoards board =
    el Styles.None
        []
        (link (threadsPath board.id) <|
            el Styles.Link [ onLinkClick (ChangeLocation (threadsPath board.id)) ] (text board.name)
        )
