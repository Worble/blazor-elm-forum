module Views.Test exposing (view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model)
import Msgs exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.text ]
        , input [ type_ "text ", onInput PostInput, value model.messageInput ] []
        , button [ onClick SendMessage ] [ text "Submit" ]
        ]
