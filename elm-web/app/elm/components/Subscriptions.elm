module Subscriptions exposing (subscriptions)

import Models exposing (Model)
import Msgs exposing (Msg(..))
import WebSocket exposing (listen)
import Window


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.board.thread.id > 0 then
            listen ("wss://evening-shore-60768.herokuapp.com/api/boards/" ++ toString model.board.id ++ "/threads/" ++ toString model.board.thread.id ++ "/posts/") ReceiveWebSocketMessage
            --listen ("ws://localhost:14190/api/boards/" ++ toString model.board.id ++ "/threads/" ++ toString model.board.thread.id ++ "/posts/") ReceiveWebSocketMessage
          else
            Sub.none
        , Window.resizes GetWindowSize
        ]
