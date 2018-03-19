module Models exposing (..)


type alias Model =
    { text : String
    , boards : List Board
    , route : Route
    , board : Board
    , input : String
    }


model : Route -> Model
model route =
    { text = ""
    , boards = []
    , board = { name = "", shorthandName = "", id = 0, threads = [], thread = { posts = [], id = 0, boardId = 0 } }
    , route = route
    , input = ""
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
    , id : Int
    , boardId : Int
    }


type alias Post =
    { id : Int
    , content : String
    , isOp : Bool
    , threadId : Int
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
