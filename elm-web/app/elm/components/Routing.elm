module Routing exposing (..)

import Models exposing (Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map BoardsRoute top
        , map ThreadsRoute (s "boards" </> int)
        , map ThreadsRoute (s "boards" </> int </> s "threads")
        , map BoardsRoute (s "boards")
        , map PostsRoute (s "boards" </> int </> s "threads" </> int)
        , map PostsRoute (s "boards" </> int </> s "threads" </> int </> s "posts")
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
    "/boards/"


threadsPath : Int -> String
threadsPath boardId =
    "/boards/" ++ toString boardId ++ "/threads/"


postsPath : Int -> Int -> String
postsPath boardId threadId =
    "/boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts/"


postPath : Int -> Int -> Int -> String
postPath boardId threadId postId =
    "/boards/" ++ toString boardId ++ "/threads/" ++ toString threadId ++ "/posts/#" ++ toString postId
