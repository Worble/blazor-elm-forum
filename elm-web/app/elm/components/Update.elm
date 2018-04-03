module Update exposing (update)

import Commands exposing (performLocationChange, sendPost, sendThread)
import Models exposing (Board, Model, Post, Route(..), Thread)
import Msgs exposing (Msg(..))
import Navigation exposing (newUrl)
import Routing exposing (errorPath, parseLocation, postsPath)
import WebSocket exposing (send)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetBoards (Ok boards) ->
            ( { model | boards = boards }, Cmd.none )

        GetBoards (Err e) ->
            ( { model | text = toString e }, newUrl errorPath )

        GetThreadsForBoard (Ok board) ->
            ( { model | board = board }, Cmd.none )

        GetThreadsForBoard (Err e) ->
            ( { model | text = toString e }, newUrl errorPath )

        GetPostsForThread (Ok board) ->
            ( { model | board = board }, Cmd.none )

        GetPostsForThread (Err e) ->
            ( { model | text = toString e }, newUrl errorPath )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, performLocationChange newRoute )

        PostInput string ->
            ( { model | messageInput = string }, Cmd.none )

        SendPost ->
            ( { model | messageInput = "" }, sendPost model.messageInput model.board.id model.board.thread.id )

        ThreadInput string ->
            ( { model | threadInput = string }, Cmd.none )

        SendThread ->
            ( { model | threadInput = "" }, sendThread model.threadInput model.board.id )

        RedirectPostsForThread (Ok board) ->
            ( { model | board = board }, newUrl (postsPath board.id board.thread.id) )

        RedirectPostsForThread (Err e) ->
            ( { model | text = toString e }, newUrl errorPath )

        Echo post ->
            ( { model | text = post }, Cmd.none )

        SendMessage boardId threadId ->
            ( { model | messageInput = "" }
            , WebSocket.send
                ("ws://localhost:14190/api/boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts/ws")
                model.messageInput
            )
