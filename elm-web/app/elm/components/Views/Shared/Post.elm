module Views.Shared.Post exposing (postView, threadView)

import Date.Extra exposing (toFormattedString)
import Element exposing (Element, column, el, image, link, newTab, paragraph, row, text, textLayout, when)
import Element.Attributes exposing (alignLeft, id, maxHeight, maxWidth, paddingXY, percent, px, spacingXY, width)
import Models exposing (Post, Thread)
import Msgs exposing (Msg(..))
import Routing exposing (postPath, postsPath)
import Styles exposing (Style(..))
import Views.Shared.OnLinkClick exposing (onLinkClick)


postView : Post -> Int -> Int -> Element Style variation Msg
postView post boardId threadId=
    column Styles.Post
        [ id (toString post.id), alignLeft, paddingXY 10 10 ]
        (displayPost post boardId threadId)


threadView : Thread -> Int -> Element Style variation Msg
threadView thread boardId =
    let
        threadLink =
            link (postsPath thread.boardId thread.id) <|
                el Styles.Link [ onLinkClick (ChangeLocation (postsPath thread.boardId thread.id)) ] (Element.text "View Thread")
    in
    column Styles.Post
        [ id (toString thread.post.id), alignLeft, paddingXY 10 10 ]
        (appendToEnd threadLink (displayPost thread.post boardId thread.id))


displayPost : Post -> Int -> Int -> List (Element Style variation Msg)
displayPost post boardId threadId =
    [ el Styles.PostHeader
        [ width (percent 100) ]
        (paragraph Styles.None
            [ spacingXY 5 0 ]
            [ text <| "Made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" post.createdDate
            , text " "
            , link (postPath boardId threadId post.id) <| el Styles.Link [] (text "No.")
            , text " "
            , el Styles.Link [] (text <| "#" ++ toString post.id)
            ]
        )
    , textLayout Styles.None
        [ spacingXY 10 0, paddingXY 0 10, width (percent 100) ]
        [ when (post.imagePath /= "")
            (el Styles.None
                [ alignLeft ]
                (newTab post.imagePath <|
                    image Styles.None
                        [ maxHeight (px 100), maxWidth (px 100) ]
                        { src = post.thumbnailPath, caption = "thread_image" }
                )
            )
        , paragraph Styles.PostText [] [ text post.content ]
        ]
    ]


appendToEnd : a -> List a -> List a
appendToEnd element list =
    List.reverse (element :: List.reverse list)
