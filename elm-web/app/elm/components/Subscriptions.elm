module Subscriptions exposing (subscriptions)

import Models exposing (Model)
import Msgs exposing (Msg(..))
import WebSocket exposing (listen)


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.board.thread.id > 0 then
        listen ("ws://localhost:14190/api/boards/" ++ toString model.board.id ++ "/threads/" ++ toString model.board.thread.id ++ "/posts/ws") Echo
    else
        Sub.none
