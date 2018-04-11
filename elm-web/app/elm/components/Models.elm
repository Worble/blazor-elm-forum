module Models exposing (..)

import Date exposing (Date)
import Element exposing (Device)
import FileReader exposing (NativeFile)
import Element

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
    , textHack = 0
    , device = initialDevice
    }

initialDevice : Element.Device
initialDevice = 
    { width = 0
    , height = 0
    , phone = True
    , tablet = False
    , desktop = False
    , bigDesktop = False
    , portrait = False
    }

emptyBoard : Board
emptyBoard =
    { name = "", shorthandName = "", id = 0, threads = [], thread = emptyThread, createdDate = Date.fromTime 0, editedDate = Date.fromTime 0 }


emptyThread : Thread
emptyThread =
    { posts = [], post = emptyPost, id = 0, boardId = 0, createdDate = Date.fromTime 0, editedDate = Date.fromTime 0, archived = False, bumpDate = Date.fromTime 0 }


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
    , textHack : Int
    , device : Device
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
    , bumpDate : Date
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
