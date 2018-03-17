module Update exposing (performLocationChange, update)

import Http
import Json.Decode as Decode exposing (Decoder, bool, field, int, list, map2, map3, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Models exposing (Board, Model, Post, Route, Thread)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetBoards (Ok boards) ->
            ( { model | boards = boards }, Cmd.none )

        GetBoards (Err e) ->
            ( { model | text = toString e }, Cmd.none )

        GetThreadsForBoard (Ok board) ->
            ( { model | board = board }, Cmd.none )

        GetThreadsForBoard (Err e) ->
            ( { model | text = toString e }, Cmd.none )

        GetPostsForThread (Ok board) ->
            ( { model | board = board }, Cmd.none )

        GetPostsForThread (Err e) ->
            ( { model | text = toString e }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, performLocationChange newRoute )


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
    Http.send GetBoards (Http.get "http://localhost:14190/api/boards/" (list decodeBoard))


decodeBoard : Decode.Decoder Board
decodeBoard =
    --map3 Board (field "name" string) (field "shorthandName" string) (field "id" int)
    decode Board
        |> required "name" string
        |> required "shorthandName" string
        |> required "id" int
        |> optional "threads" (list decodeThread) []
        |> optional "thread" decodeThread { posts = [], id = 0 }


getThreads : a -> Cmd Msg
getThreads boardId =
    Http.send GetThreadsForBoard (Http.get ("http://localhost:14190/api/boards/" ++ toString boardId ++ "/threads") decodeBoard)


decodeThread : Decode.Decoder Thread
decodeThread =
    --map2 Thread (field "posts" (list decodePost)) (field "id" int)
    decode Thread
        |> optional "posts" (list decodePost) []
        |> required "id" int


getPosts : a -> a -> Cmd Msg
getPosts boardId threadId =
    Http.send GetPostsForThread (Http.get ("http://localhost:14190/api/boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts") decodeBoard)


decodePost : Decode.Decoder Post
decodePost =
    map3 Post (field "id" int) (field "content" string) (field "isOp" bool)
