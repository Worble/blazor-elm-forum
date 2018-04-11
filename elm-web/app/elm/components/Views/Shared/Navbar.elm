module Views.Shared.Navbar exposing (view)

import Element exposing (Element, el, layout, link, navigation, row, text, when)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Styles exposing (Style(..), stylesheet)
import Views.Shared.OnLinkClick exposing (onLinkClick)


view : Model -> Element Style variation Msg
view model =
    when (model.boards /= [])
        (row None [] (el Styles.None [] (text "Boards: ") :: List.map displayBoards model.boards))


displayBoards : Board -> Element Style variation Msg
displayBoards board =
    row None
        []
        [ link (threadsPath board.id) <| el Styles.Link [ onLinkClick (ChangeLocation (threadsPath board.id)) ] (text board.name)
        , el Styles.None [] (text " | ")
        ]
