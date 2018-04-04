module Models exposing (..)

import FileReader exposing (NativeFile)


--INITIAL MODELS


model : Route -> Model
model route =
    { text = ""
    , boards = []
    , board = emptyBoard
    , route = route
    , messageInput = ""
    , file = Nothing
    , readFile = ""
    }


emptyBoard : Board
emptyBoard =
    { name = "", shorthandName = "", id = 0, threads = [], thread = emptyThread }


emptyThread : Thread
emptyThread =
    { posts = [], post = emptyPost, id = 0, boardId = 0 }


emptyPost : Post
emptyPost =
    { id = 0, content = "", isOp = False, threadId = 0, image = "", imagePath = "", thumbnailPath = "", createdDate = "" }



--MODELS


type alias Model =
    { text : String
    , boards : List Board
    , route : Route
    , board : Board
    , messageInput : String
    , file : Maybe NativeFile
    , readFile : String
    }


type alias Board =
    { name : String
    , shorthandName : String
    , id : Int
    , threads : List Thread
    , thread : Thread
    }


type alias Thread =
    { posts : List Post
    , post : Post
    , id : Int
    , boardId : Int
    }


type alias Post =
    { id : Int
    , content : String
    , isOp : Bool
    , threadId : Int
    , image : String
    , imagePath : String
    , thumbnailPath : String
    , createdDate : String
    }


type alias BoardId =
    String


type alias PostId =
    String


type Route
    = BoardsRoute
    | ThreadsRoute Int
    | PostsRoute Int Int
    | NotFoundRoute
