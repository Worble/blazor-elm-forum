module Encoders exposing (postEncoder, threadEncoder)

import Json.Encode as Encode


postEncoder : String -> Int -> Encode.Value
postEncoder message threadId =
    Encode.object
        [ ( "content", Encode.string message )
        , ( "threadId", Encode.int threadId )
        ]


threadEncoder : String -> Int -> Encode.Value
threadEncoder message boardId =
    Encode.object
        [ ( "boardId", Encode.int boardId )
        , ( "posts", Encode.list (List.map (\n -> postEncoder n 0) [ message ]) )
        ]
