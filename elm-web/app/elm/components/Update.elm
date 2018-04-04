module Update exposing (update)

import Commands exposing (getFileContents, performLocationChange, sendPost, sendThread)
import Json.Decode exposing (decodeString, string)
import Json.Encode exposing (encode)
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
            ( { model | route = newRoute, messageInput = "", readFile = "" }, performLocationChange newRoute )

        PostInput string ->
            ( { model | messageInput = string }, Cmd.none )

        SendPost ->
            ( { model | messageInput = "", readFile = "" }, sendPost model.readFile model.messageInput model.board.id model.board.thread.id )

        SendThread ->
            ( { model | messageInput = "", readFile = "" }, sendThread model.readFile model.messageInput model.board.id )

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

        UploadFile file ->
            case file of
                [ f ] ->
                    ( { model | file = Just f }, getFileContents f )

                _ ->
                    ( model, Cmd.none )

        OnFileContent res ->
            case res of
                Ok content ->
                    ( { model | readFile = String.dropRight 1 (String.dropLeft 1 (toString content)) }, Cmd.none )

                Err err ->
                    Debug.crash (toString err)
