module Msgs exposing (..)

import Http exposing (Error)
import Models exposing (Board, Post, Thread)
import Navigation exposing (Location)


type Msg
    = NoOp
    | GetBoards (Result Error (List Board))
    | GetThreadsForBoard (Result Error Board)
    | GetPostsForThread (Result Error Board)
    | OnLocationChange Location
    | PostInput String
    | SendPost
    | ThreadInput String
    | SendThread
