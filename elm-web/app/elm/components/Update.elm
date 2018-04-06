module Update exposing (update)

import Commands exposing (getFileContents, performLocationChange, sendPost, sendPostWebSocket, sendThread)
import Date.Extra as Date exposing (compare)
import Decoders exposing (decodeBoard)
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
            ( { model | text = toString e }, Cmd.none )

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
            ( { model | text = toString e }, newUrl errorPath )

        Echo board ->
            let
                decodedBoard =
                    case decodeString decodeBoard board of
                        Ok board ->
                            board

                        Err _ ->
                            emptyBoard
            in
            ( { model | board = decodedBoard }, Cmd.none )

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
