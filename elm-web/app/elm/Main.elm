module Main exposing (..)

import Commands exposing (getBoards, performLocationChange)
import Models exposing (Model, model)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Routing
import Subscriptions exposing (subscriptions)
import Task
import Update exposing (update)
import View exposing (view)
import Window


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        hash =
            Routing.parseLocationHash location
    in
    ( model currentRoute, Cmd.batch [ performLocationChange currentRoute hash, getBoards, Task.perform GetWindowSize Window.size ] )


main : Program Never Model Msg
main =
    --Html.program
    Navigation.program Msgs.OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
