module Views.Shared.Navbar exposing (view)

import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Routing exposing (threadsPath)
import Views.Shared.OnLinkClick exposing (onLinkClick)
import Element exposing (el, row, link, Element, layout, text, navigation, when)
import Styles exposing (Styles(..), stylesheet)


view : Model -> Element Styles variation Msg
view model =
    when (model.boards /= []) 
        (row None [] (el Styles.None [] (text "Boards: ") :: List.map displayBoards model.boards))

displayBoards : Board -> Element Styles variation Msg
displayBoards board =
    row None [] 
     [ (link (threadsPath board.id) <| el Styles.Link [ onLinkClick (ChangeLocation (threadsPath board.id)) ] (text (board.name)))
     , el Styles.None [] (text " | ")
     ]