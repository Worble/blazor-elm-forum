module View exposing (view)

import Element exposing (column, el, empty, layout, responsive, text, when)
import Element.Attributes exposing (center, px, width)
import Html exposing (Html)
import Models exposing (Board, Model)
import Msgs exposing (Msg(..))
import Styles exposing (Style(..), stylesheet)
import Views.Boards
import Views.Posts
import Views.Shared.Error exposing (view)
import Views.Shared.Navbar exposing (view)
import Views.Threads


view : Model -> Html Msg
view model =
    layout stylesheet <|
        el Styles.None
            (bodyPosition model.device)
            (column Styles.None
                []
                [ when (model.error /= "")
                    (Views.Shared.Error.view model)
                , Views.Shared.Navbar.view model
                , case model.route of
                    Models.BoardsRoute ->
                        Views.Boards.view model

                    Models.ThreadsRoute threadId ->
                        Views.Threads.view model

                    Models.PostsRoute threadId postId ->
                        Views.Posts.view model

                    Models.NotFoundRoute ->
                        el Styles.None [] empty
                ]
            )

bodyPosition device =
    let
        currentWidth =
            toFloat device.width

        responsiveWidth =
            responsive (toFloat device.width) ( 400, 1800 ) ( 400, 1200 )
    in
    if currentWidth > 399 then
        [ center, width (px responsiveWidth) ]
    else
        [ width (px 400) ]
