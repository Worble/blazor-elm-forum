module Views.Shared.OnLinkClick exposing (onLinkClick)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode as Decode
import Element exposing (Attribute)
import Element.Events exposing (..)


onLinkClick : msg -> Element.Attribute variation msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
    Element.Events.onWithOptions "click" options (Decode.succeed message)
