module Update exposing (update)

import Commands exposing (performLocationChange, sendPost, sendThread)
import Models exposing (Board, Model, Post, Route(..), Thread)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetBoards (Ok boards) ->
            ( { model | boards = boards, route = BoardsRoute }, Cmd.none )

        GetBoards (Err e) ->
            ( { model | text = toString e }, Cmd.none )

        GetThreadsForBoard (Ok board) ->
            ( { model | board = board, route = ThreadsRoute board.id }, Cmd.none )

        GetThreadsForBoard (Err e) ->
            ( { model | text = toString e }, Cmd.none )

        GetPostsForThread (Ok board) ->
            ( { model | board = board, route = PostsRoute board.id board.thread.id }, Cmd.none )

        GetPostsForThread (Err e) ->
            ( { model | text = toString e }, Cmd.none )

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
