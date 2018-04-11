module Views.Shared.OnLinkClick exposing (onLinkClick)


import Json.Decode as Decode
import Element exposing (Attribute)
import Element.Events as Events


onLinkClick : msg -> Element.Attribute variation msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
    Events.onWithOptions "click" options (Decode.succeed message)
