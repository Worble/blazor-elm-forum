module Msgs exposing (..)

import FileReader exposing (FileContentDataUrl, NativeFile)
import Http exposing (Error)
import Models exposing (Board, Post, Thread)
import Navigation exposing (Location)
import Window


type Msg
    = NoOp
    | GetBoards (Result Error (List Board))
    | GetThreadsForBoard (Result Error Board)
    | GetPostsForThread (Result Error Board)
    | GetPostsForThreadScroll (Result Error Board)
    | OnLocationChange Location
    | PostInput String
    | PostInputAppend String
    | SendPost
    | SendThread
    | RedirectPostsForThread (Result Error Board)
    | ReceiveWebSocketMessage String
    | UploadFile (List NativeFile)
    | OnFileContent (Result FileReader.Error FileContentDataUrl)
    | SendPostWebSocket
    | RemoveError
    | ChangeLocation String
    | GetWindowSize Window.Size
    | Dummy (Result Error Board)
