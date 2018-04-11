module Views.Shared.Post exposing (postView, threadView)

import Date.Extra exposing (toFormattedString)
import Element exposing (Element, column, el, image, link, newTab, paragraph, text, textLayout, when)
import Element.Attributes exposing (alignLeft, maxHeight, maxWidth, paddingXY, percent, px, spacing, width)
import Models exposing (Post, Thread)
import Msgs exposing (Msg(..))
import Routing exposing (postsPath)
import Styles exposing (Style(..))
import Views.Shared.OnLinkClick exposing (onLinkClick)


postView : Post -> Element Style variation Msg
postView post =
    column Styles.Post
        [ alignLeft, paddingXY 10 10 ]
        (displayPost post)

threadView : Thread -> Element Style variation Msg
threadView thread =
    let
        threadLink =
            link (postsPath thread.boardId thread.id) <|
                el Styles.Link [ onLinkClick (ChangeLocation (postsPath thread.boardId thread.id)) ] (Element.text "View Thread")
    in
        column Styles.Post
            [ alignLeft, paddingXY 10 10 ]
            (appendToEnd threadLink (displayPost thread.post))


displayPost : Post -> List (Element Style variation Msg)
displayPost post =
    [ el Styles.PostHeader
        []
        (text ("No. #" ++ toString post.id ++ " made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" post.createdDate))
    , textLayout Styles.None
        [ spacing 10, paddingXY 0 10, width (percent 100) ]
        [ when (post.imagePath /= "")
            (el Styles.None
                [ alignLeft ]
                (newTab post.imagePath <|
                    image Styles.None
                        [ maxHeight (px 200), maxWidth (px 200) ]
                        { src = post.thumbnailPath, caption = "thread_image" }
                )
            )
        , Element.paragraph Styles.None [] [ text post.content ]
        ]
    ]

appendToEnd : a -> List a -> List a
appendToEnd element list =
    (List.reverse (element :: List.reverse(list)))
