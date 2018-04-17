module Routing exposing (..)

import Models exposing (Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map BoardsRoute top
        , map ThreadsRoute (string)
        , map PostsRoute (string </> int)
        ]


parseLocation : Location -> Route
parseLocation location =
    case parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


parseLocationHash : Location -> Maybe Int
parseLocationHash location =
    parseHash int location


errorPath : String
errorPath =
    "/404/"


boardsPath : String
boardsPath =
    "/"


threadsPath : String -> String
threadsPath boardName =
    "/" ++ boardName ++ "/"


postsPath : String -> Int -> String
postsPath boardName threadId =
    "/" ++ boardName ++ "/" ++ toString threadId ++ "/"


postPath : String -> Int -> Int -> String
postPath boardName threadId postId =
    "/" ++ boardName ++ "/" ++ toString threadId ++ "#" ++ toString postId
