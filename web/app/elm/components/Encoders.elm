module Encoders exposing (postEncoder)

import Json.Encode as Encode

postEncoder : String -> Int -> Encode.Value
postEncoder message threadId =
    Encode.object
    [ ( "content", Encode.string message )
    , ("threadId", Encode.int threadId)
    ]