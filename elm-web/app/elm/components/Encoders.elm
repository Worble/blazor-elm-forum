module Encoders exposing (postEncoder, threadEncoder)

import Json.Encode as Encode


postEncoder : String -> String -> Int -> Encode.Value
postEncoder data message threadId =
    Encode.object
        [ ( "content", Encode.string message )
        , ( "threadId", Encode.int threadId )
        , ( "image", Encode.string data )
        ]


threadEncoder : String -> String -> Int -> Encode.Value
threadEncoder data message boardId =
    Encode.object
        [ ( "boardId", Encode.int boardId )
        , ( "post", postEncoder data message 0 )
        ]
