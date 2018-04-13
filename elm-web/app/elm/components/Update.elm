module Update exposing (update)

import Commands exposing (getFileContents, performLocationChange, sendPost, sendPostWebSocket, sendThread)
import Date.Extra as Date exposing (compare)
import Decoders exposing (decodeBoard, returnError)
import Dom.Scroll
import Element
import Http exposing (Error)
import Json.Decode as Decode exposing (decodeString, field, string)
import Models exposing (Board, Model, Post, Route(..), Thread, emptyBoard)
import Msgs exposing (Msg(..))
import Navigation exposing (newUrl)
import Ports exposing (scrollIdIntoView)
import Routing exposing (errorPath, parseLocation, parseLocationHash, postsPath)
import Task


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
                    List.sortWith (\t1 t2 -> Date.compare t1.bumpDate t2.bumpDate) board.threads
                        |> List.reverse

                oldBoard =
                    model.board

                newBoard =
                    if board.id == model.board.id then
                        { oldBoard | threads = sortedThreads }
                    else
                        { board | threads = sortedThreads }
            in
            ( { model | board = newBoard }, Cmd.none )

        GetThreadsForBoard (Err e) ->
            httpError e model

        GetPostsForThread (Ok board) ->
            let
                sortedPosts =
                    List.sortWith (\t1 t2 -> Date.compare t1.createdDate t2.createdDate) board.thread.posts

                oldBoard =
                    model.board

                newThread =
                    board.thread

                newThreadWithSortedPosts =
                    { newThread | posts = sortedPosts }

                newBoard =
                    if board.id == model.board.id then
                        { oldBoard | thread = newThreadWithSortedPosts }
                    else
                        { board | thread = newThreadWithSortedPosts }

                cmd =
                    if board.thread.post.id == 0 then
                        Cmd.none
                    else
                        scrollIdIntoView (toString board.thread.post.id)

                dummy =
                    Debug.log ":" cmd

                --Task.attempt (always NoOp) <| Dom.Scroll.toY (toString board.thread.post.id)
            in
            ( { model | board = newBoard }, cmd )

        GetPostsForThread (Err e) ->
            httpError e model

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                hash =
                    parseLocationHash location
            in
            ( { model | route = newRoute, messageInput = "", readFile = "", socketGuid = "" }, performLocationChange newRoute hash )

        ChangeLocation path ->
            ( model, newUrl path )

        PostInput string ->
            ( { model | messageInput = string }, Cmd.none )

        SendPost ->
            ( { model | messageInput = "", readFile = "", file = Nothing, textHack = model.textHack + 1 }
            , sendPost model.readFile model.messageInput model.board.id model.board.thread.id
            )

        SendPostWebSocket ->
            ( { model | messageInput = "", readFile = "", file = Nothing, textHack = model.textHack + 1 }
            , sendPostWebSocket model.socketGuid model.readFile model.messageInput model.board.id model.board.thread.id
            )

        SendThread ->
            ( { model | messageInput = "", readFile = "", file = Nothing, textHack = model.textHack + 1 }
            , sendThread model.readFile model.messageInput model.board.id
            )

        RedirectPostsForThread (Ok board) ->
            ( { model | board = board }, newUrl (postsPath board.id board.thread.id) )

        RedirectPostsForThread (Err e) ->
            httpError e model

        ReceiveWebSocketMessage jsonString ->
            let
                newModel =
                    case decodeString decodeBoard jsonString of
                        Ok board ->
                            { model | board = board }

                        Err _ ->
                            case decodeString (field "guid" string) jsonString of
                                Ok guid ->
                                    { model | socketGuid = guid }

                                Err _ ->
                                    { model | error = returnError jsonString }
            in
            ( newModel, Cmd.none )

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
                    ( { model | error = toString err }, Cmd.none )

        RemoveError ->
            ( { model | error = "" }, Cmd.none )

        GetWindowSize size ->
            let
                device =
                    Element.classifyDevice size
            in
            ( { model | device = device }, Cmd.none )

        Scroll ->
            let
                cmd =
                    if model.board.thread.post.id == 0 then
                        Cmd.none
                    else
                        scrollIdIntoView (toString model.board.thread.post.id)
            in
            ( model, cmd )


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
