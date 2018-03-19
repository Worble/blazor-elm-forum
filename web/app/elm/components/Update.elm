module Update exposing (update)

import Commands exposing (performLocationChange, sendPost)
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

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, performLocationChange newRoute )

        PostInput string ->
            ( { model | input = string }, Cmd.none )

        SendPost ->
            ( { model | input = "" }, sendPost model.input model.board.id model.board.thread.id )
