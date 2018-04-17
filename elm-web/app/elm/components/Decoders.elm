module Decoders exposing (decodeBoard, returnError)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder, andThen, bool, decodeString, fail, field, int, list, map4, nullable, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Models exposing (Board, Post, Thread, emptyPost, emptyThread)


decodeBoard : Decode.Decoder Board
decodeBoard =
    --map3 Board (field "name" string) (field "shorthandName" string) (field "id" int)
    decode Board
        |> required "name" string
        |> required "shorthandName" string
        |> required "id" int
        |> optional "threads" (list decodeThread) []
        |> optional "thread" decodeThread emptyThread
        |> required "createdDate" decodeDate
        |> optional "editedDate" decodeDate (Date.fromTime 0)


decodeThread : Decode.Decoder Thread
decodeThread =
    --map2 Thread (field "posts" (list decodePost)) (field "id" int)
    decode Thread
        |> optional "posts" (list decodePost) []
        |> optional "post" decodePost emptyPost
        |> required "id" int
        |> required "boardId" int
        |> required "createdDate" decodeDate
        |> optional "editedDate" decodeDate (Date.fromTime 0)
        |> required "archived" bool
        |> required "bumpDate" decodeDate
        |> required "opPost" decodePost


decodePost : Decode.Decoder Post
decodePost =
    --map4 Post (field "id" int) (field "content" string) (field "isOp" bool) (field "threadId" int)
    decode Post
        |> required "id" int
        |> optional "content" string ""
        |> required "isOp" bool
        |> required "threadId" int
        |> optional "image" string ""
        |> optional "imagePath" string ""
        |> optional "thumbnailPath" string ""
        |> required "createdDate" decodeDate
        |> optional "editedDate" decodeDate (Date.fromTime 0)


decodeDate : Decode.Decoder Date
decodeDate =
    let
        convert : String -> Decoder Date
        convert raw =
            case Date.fromString raw of
                Ok date ->
                    succeed date

                Err error ->
                    fail error
    in
    string
        |> andThen convert


returnError : String -> String
returnError error =
    case decodeString (field "message" string) error of
        Ok msg ->
            msg

        Err e ->
            error
