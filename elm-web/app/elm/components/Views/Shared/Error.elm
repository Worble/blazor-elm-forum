module Views.Shared.Error exposing (view)

import Element exposing (Element, el, paragraph, row, screen, text)
import Element.Attributes exposing (center, padding, percent, width)
import Element.Events exposing (onClick)
import Models exposing (Model)
import Msgs exposing (Msg(..))
import Styles exposing (Style(..), stylesheet)


view : Model -> Element Style variation Msg
view model =
    screen
        (row Styles.Error
            [ width (percent 100), center, onClick RemoveError ]
            [ paragraph Styles.None
                [ padding 20 ]
                [text ("Error: " ++ model.error)]
            ]
        )
