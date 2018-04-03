module Commands exposing (getBoards, performLocationChange, sendPost, sendThread)

import Decoders exposing (decodeBoard)
import Encoders exposing (postEncoder, threadEncoder)
import Http
import Json.Decode exposing (list)
import Json.Encode as Encode
import Models exposing (Route)
import Msgs exposing (Msg(..))


api : String
api =
    "http://localhost:14190/api/"


sendPost : String -> Int -> Int -> Cmd Msg
sendPost post boardId threadId =
    let
        url =
            api ++ "boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts"

        request =
            Http.post
                url
                (Http.stringBody "application/json" <| Encode.encode 0 <| postEncoder post threadId)
                decodeBoard
    in
    Http.send GetPostsForThread request


sendThread : String -> Int -> Cmd Msg
sendThread post boardId =
    let
        url =
            api ++ "boards/" ++ toString boardId ++ "/threads"

        request =
            Http.post
                url
                (Http.stringBody "application/json" <| Encode.encode 0 <| threadEncoder post boardId)
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
