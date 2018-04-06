module Commands exposing (getBoards, getFileContents, performLocationChange, sendPost, sendPostWebSocket, sendThread)

import Decoders exposing (decodeBoard)
import Encoders exposing (postEncoder, threadEncoder)
import FileReader exposing (NativeFile)
import Http
import Json.Decode as Decode exposing (list, string)
import Json.Encode as Encode
import Models exposing (Route)
import Msgs exposing (Msg(..))
import Task
import WebSocket exposing (send)


api : String
api =
    "http://localhost:14190/api/"


sendPost : String -> String -> Int -> Int -> Cmd Msg
sendPost data post boardId threadId =
    let
        url =
            api ++ "boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts"

        request =
            Http.post
                url
                (Http.stringBody "application/json" <| Encode.encode 0 <| postEncoder data post threadId)
                decodeBoard
    in
    Http.send GetPostsForThread request


sendPostWebSocket : String -> String -> Int -> Int -> Cmd Msg
sendPostWebSocket data post boardId threadId =
    let
        url =
            "ws://localhost:14190/api/boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts/ws"

        json =
            Encode.encode 0 <| postEncoder data post threadId
    in
    WebSocket.send url json


sendThread : String -> String -> Int -> Cmd Msg
sendThread data post boardId =
    let
        url =
            api ++ "boards/" ++ toString boardId ++ "/threads"

        request =
            Http.post
                url
                (Http.stringBody "application/json" <| Encode.encode 0 <| threadEncoder data post boardId)
                decodeBoard
    in
    Http.send RedirectPostsForThread request


performLocationChange : Route -> Cmd Msg
performLocationChange route =
    case route of
        Models.BoardsRoute ->
            getBoards

        Models.ThreadsRoute boardId ->
            getThreads boardId

        Models.PostsRoute boardId threadId ->
            getPosts boardId threadId

        Models.NotFoundRoute ->
            Cmd.none


getBoards : Cmd Msg
getBoards =
    let
        url =
            api ++ "boards/"
    in
    Http.send GetBoards (Http.get url (list decodeBoard))


getThreads : a -> Cmd Msg
getThreads boardId =
    let
        url =
            api ++ "boards/" ++ toString boardId ++ "/threads"
    in
    Http.send GetThreadsForBoard (Http.get url decodeBoard)


getPosts : a -> a -> Cmd Msg
getPosts boardId threadId =
    let
        url =
            api ++ "boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts"
    in
    Http.send GetPostsForThread (Http.get url decodeBoard)


getFileContents : NativeFile -> Cmd Msg
getFileContents nf =
    FileReader.readAsDataUrl nf.blob
        |> Task.attempt OnFileContent
