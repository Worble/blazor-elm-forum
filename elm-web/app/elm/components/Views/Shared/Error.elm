module Views.Shared.Error exposing (view)

import Models exposing (Model)
import Element exposing (Element, text, el, screen, row)
import Element.Attributes exposing (padding, width, percent, center)
import Element.Events exposing (onClick)
import Msgs exposing (Msg(..))
import Styles exposing (Style(..), stylesheet)

view : Model -> Element Style variation Msg
view model =
    screen 
        (row Styles.Error 
            [ width (percent 100), center, onClick RemoveError ] 
            [ el Styles.None 
                [ padding 20 ] 
                (text ("Error: " ++ model.error))
            ]
        )