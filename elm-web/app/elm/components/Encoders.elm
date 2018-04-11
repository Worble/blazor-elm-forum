module Encoders exposing (postEncoder, threadEncoder, webSocketEncoder)

import Json.Encode as Encode


postEncoder : String -> String -> Int -> Encode.Value
postEncoder imageData message threadId =
    Encode.object
        [ ( "content", Encode.string message )
        , ( "threadId", Encode.int threadId )
        , ( "image", Encode.string imageData )
        ]


threadEncoder : String -> String -> Int -> Encode.Value
threadEncoder imageData message boardId =
    Encode.object
        [ ( "boardId", Encode.int boardId )
        , ( "post", postEncoder imageData message 0 )
        ]

webSocketEncoder : String -> String -> String -> Int -> Encode.Value
webSocketEncoder guid imageData message threadId =
    Encode.object
        [ ( "guid", Encode.string guid )
        , ( "post", postEncoder imageData message 0 )
        ]