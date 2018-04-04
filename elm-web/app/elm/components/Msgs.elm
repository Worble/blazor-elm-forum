module Msgs exposing (..)

import Http exposing (Error)
import Models exposing (Board, Post, Thread)
import Navigation exposing (Location)
import FileReader exposing (NativeFile, FileContentDataUrl)


type Msg
    = NoOp
    | GetBoards (Result Error (List Board))
    | GetThreadsForBoard (Result Error Board)
    | GetPostsForThread (Result Error Board)
    | OnLocationChange Location
    | PostInput String
    | SendPost
    | SendThread
    | RedirectPostsForThread (Result Error Board)
    | Echo String
    | SendMessage Int Int
    | UploadFile (List NativeFile)
    | OnFileContent (Result FileReader.Error FileContentDataUrl)