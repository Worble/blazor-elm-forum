module Styles exposing (Style(..), stylesheet)

import Color exposing (..)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Style.Scale as Scale


type Style
    = None
    | Title
    | Link
    | PostHeader
    | Post
    | Error
    | PostText
    | TextInput


scale : Int -> Float
scale =
    Scale.modular 16 1.618


stylesheet : StyleSheet Style variation
stylesheet =
    Style.styleSheet
        [ style None []
        , style Title
            [ Font.size (scale 2)
            , Font.bold
            ]
        , style Link
            [ Font.size (scale 1)
            , Color.text Color.darkBlue
            , hover
                [ Font.underline
                ]
            ]
        , style PostHeader
            [ Border.bottom 1
            , Border.solid
            ]
        , style Post
            [ Color.background Color.lightGray
            , prop "word-wrap" "break-word"
            , prop "word-break" "break-word"
            ]
        , style PostText
            [ prop "white-space" "pre-line"
            ]
        , style Error
            [ Color.background (Color.rgb 255 213 213)
            , Style.cursor "pointer"
            ]
        , style TextInput
            [ Border.all 1
            , Border.solid
            , Color.border lightGray
            , prop "resize" "vertical!important"
            ]
        ]
