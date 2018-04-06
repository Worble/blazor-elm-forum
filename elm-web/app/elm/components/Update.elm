module Update exposing (update)

import Commands exposing (getFileContents, performLocationChange, sendPost, sendPostWebSocket, sendThread)
import Date.Extra as Date exposing (compare)
import Decoders exposing (decodeBoard, returnError)
import Http exposing (Error)
import Json.Decode exposing (decodeString)
import Models exposing (Board, Model, Post, Route(..), Thread, emptyBoard)
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
            httpError e model


        GetThreadsForBoard (Ok board) ->
            let
                sortedThreads =
                    --List.sortWith DateExtra.compare board.threads
                    List.sortWith (\t1 t2 -> Date.compare t1.editedDate t2.editedDate) board.threads
                        |> List.reverse

                newBoard =
                    { board | threads = sortedThreads }
            in
            ( { model | board = newBoard }, Cmd.none )

        GetThreadsForBoard (Err e) ->
            httpError e model


        GetPostsForThread (Ok board) ->
            ( { model | board = board }, Cmd.none )

        GetPostsForThread (Err e) ->
            httpError e model


        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute, messageInput = "", readFile = "" }, performLocationChange newRoute )

        PostInput string ->
            ( { model | messageInput = string }, Cmd.none )

        SendPost ->
            ( { model | messageInput = "", readFile = "", file = Nothing }, sendPost model.readFile model.messageInput model.board.id model.board.thread.id )

        SendPostWebSocket ->
            ( { model | messageInput = "", readFile = "", file = Nothing }, sendPostWebSocket model.readFile model.messageInput model.board.id model.board.thread.id )

        SendThread ->
            ( { model | messageInput = "", readFile = "", file = Nothing }, sendThread model.readFile model.messageInput model.board.id )

        RedirectPostsForThread (Ok board) ->
            ( { model | board = board }, newUrl (postsPath board.id board.thread.id) )

        RedirectPostsForThread (Err e) ->
            httpError e model

        Echo board ->
            let
                newModel =
                    case decodeString decodeBoard board of
                        Ok board ->
                            { model | board = board }

                        Err e ->
                            { model | error = returnError board }
            in
            ( newModel, Cmd.none )

        SendMessage boardId threadId ->
            ( { model | messageInput = "" }
            , WebSocket.send
                ("ws://localhost:14190/api/boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts/")
                --"ws://localhost:14190/api/test/postshub"
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

        RemoveError ->
            ( { model | error = "" }, Cmd.none )


httpError : Error -> Model -> ( Model, Cmd Msg )
httpError e model =
    let
        error =
            case e of
                Http.BadStatus r ->
                    returnError r.body

                _ ->
                    toString e
    in
    ( { model | error = error }, Cmd.none )
