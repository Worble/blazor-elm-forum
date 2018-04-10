module View exposing (view)

-- import Html exposing (Html, div, li, text, ul)
-- import Html.Attributes exposing (style)
-- import Html.Events exposing (onClick)
import Html exposing (Html)
import Element exposing (column, layout, el, text, when, empty)
import Styles exposing (Styles(..), stylesheet)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Views.Boards
import Views.Posts
import Views.Threads
import Views.Shared.Navbar exposing (view)


view : Model -> Html Msg
view model =
    layout stylesheet <|
        column Styles.None []
            [ when (model.error /= "")
                (el Styles.None [] (text ("Error: " ++ model.error)))
            , Views.Shared.Navbar.view model
            , case model.route of
                Models.BoardsRoute ->
                    Views.Boards.view model

                Models.ThreadsRoute threadId ->
                    Views.Threads.view model

                Models.PostsRoute threadId postId ->
                    Views.Posts.view model

                Models.NotFoundRoute ->
                    el Styles.None [] (empty)
            ]

    -- div []
    --     [ if model.error /= "" then
    --         div
    --             [ onClick RemoveError
    --             , style
    --                 [ ( "background-color", "blanchedalmond" )
    --                 , ( "min-height", "50px" )
    --                 , ( "text-align", "center" )
    --                 , ( "font-size", "24px" )
    --                 , ( "cursor", "pointer" )
    --                 ]
    --             ]
    --             [ text ("Error: " ++ model.error) ]
    --       else
    --         text ""
    --     , Views.Shared.Navbar.view model
    --     , case model.route of
    --         Models.BoardsRoute ->
    --             Views.Boards.view model

    --         Models.ThreadsRoute threadId ->
    --             Views.Threads.view model

    --         Models.PostsRoute threadId postId ->
    --             Views.Posts.view model

    --         Models.NotFoundRoute ->
    --             text ""
    --     ]
