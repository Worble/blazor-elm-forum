module Main exposing (..)

import Commands exposing (getBoards, performLocationChange)
import Models exposing (Model, model)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Routing
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
    ( model currentRoute, Cmd.batch [ performLocationChange currentRoute, getBoards ] )


main : Program Never Model Msg
main =
    --Html.program
    Navigation.program Msgs.OnLocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
