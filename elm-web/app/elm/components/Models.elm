module Models exposing (..)

import Date exposing (Date)
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
    , error = ""
    }


emptyBoard : Board
emptyBoard =
    { name = "", shorthandName = "", id = 0, threads = [], thread = emptyThread, createdDate = Date.fromTime 0, editedDate = Date.fromTime 0 }


emptyThread : Thread
emptyThread =
    { posts = [], post = emptyPost, id = 0, boardId = 0, createdDate = Date.fromTime 0, editedDate = Date.fromTime 0, archived = False }


emptyPost : Post
emptyPost =
    { id = 0, content = "", isOp = False, threadId = 0, image = "", imagePath = "", thumbnailPath = "", createdDate = Date.fromTime 0, editedDate = Date.fromTime 0 }



--MODELS


type alias Model =
    { text : String
    , boards : List Board
    , route : Route
    , board : Board
    , messageInput : String
    , file : Maybe NativeFile
    , readFile : String
    , error : String
    }


type alias Board =
    { name : String
    , shorthandName : String
    , id : Int
    , threads : List Thread
    , thread : Thread
    , createdDate : Date
    , editedDate : Date
    }


type alias Thread =
    { posts : List Post
    , post : Post
    , id : Int
    , boardId : Int
    , createdDate : Date
    , editedDate : Date
    , archived : Bool
    }


type alias Post =
    { id : Int
    , content : String
    , isOp : Bool
    , threadId : Int
    , image : String
    , imagePath : String
    , thumbnailPath : String
    , createdDate : Date
    , editedDate : Date
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
