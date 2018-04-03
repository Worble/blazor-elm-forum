module Decoders exposing (decodeBoard)

import Json.Decode as Decode exposing (Decoder, bool, field, int, list, map4, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Models exposing (Board, Post, Thread, emptyThread, emptyPost)


decodeBoard : Decode.Decoder Board
decodeBoard =
    --map3 Board (field "name" string) (field "shorthandName" string) (field "id" int)
    decode Board
        |> required "name" string
        |> required "shorthandName" string
        |> required "id" int
        |> optional "threads" (list decodeThread) []
        |> optional "thread" decodeThread emptyThread


decodeThread : Decode.Decoder Thread
decodeThread =
    --map2 Thread (field "posts" (list decodePost)) (field "id" int)
    decode Thread
        |> optional "posts" (list decodePost) []
        |> optional "post" decodePost emptyPost
        |> required "id" int
        |> required "boardId" int


decodePost : Decode.Decoder Post
decodePost =
    map4 Post (field "id" int) (field "content" string) (field "isOp" bool) (field "threadId" int)
