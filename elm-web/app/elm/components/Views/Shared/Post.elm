module Views.Shared.Post exposing (postView, threadView)

import Date.Extra exposing (toFormattedString)
import Element exposing (Element, column, el, image, link, newTab, paragraph, row, text, textLayout, when)
import Element.Attributes exposing (alignLeft, id, maxHeight, maxWidth, paddingXY, percent, px, spacingXY, width)
import Element.Events exposing (onClick)
import Models exposing (Post, Thread)
import Msgs exposing (Msg(..))
import Routing exposing (postPath, postsPath)
import Styles exposing (Style(..))
import Views.Shared.OnLinkClick exposing (onLinkClick)


postView : Post -> String -> Int -> Element Style variation Msg
postView post boardName threadId =
    column Styles.Post
        [ id (toString post.id), alignLeft, paddingXY 10 10 ]
        (displayPost post boardName threadId)


threadView : Thread -> String -> Element Style variation Msg
threadView thread boardName =
    let
        threadLink =
            link (postsPath boardName thread.opPost.id) <|
                el Styles.Link
                    [ onLinkClick <| ChangeLocation (postsPath boardName thread.opPost.id) ]
                    (Element.text "View Thread")
    in
    column Styles.Post
        [ id (toString thread.opPost.id), alignLeft, paddingXY 10 10 ]
        (appendToEnd threadLink (displayPost thread.opPost boardName thread.opPost.id))


displayPost : Post -> String -> Int -> List (Element Style variation Msg)
displayPost post boardName threadId =
    [ el Styles.PostHeader
        [ width (percent 100) ]
        (paragraph Styles.None
            [ spacingXY 5 0 ]
            [ text <| "Made at " ++ toFormattedString "EEEE, MMMM d, y 'at' h:mm a" post.createdDate
            , text " "
            , if post.isOp then
                link (postsPath boardName post.id) <|
                    el Styles.Link
                        [ onLinkClick <| ChangeLocation (postsPath boardName post.id) ]
                        (text "No.")
              else
                link (postPath boardName threadId post.id) <|
                    el Styles.Link
                        [ onLinkClick <| ChangeLocation (postPath boardName threadId post.id) ]
                        (text "No.")
            , text " "
            , el Styles.Link
                [ onClick (PostInputAppend <| ">>" ++ toString post.id ++ "\n")
                ]
                (text <| "#" ++ toString post.id)
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
        , paragraph Styles.PostText [] (formatPostText post.content boardName)
        ]
    ]


appendToEnd : a -> List a -> List a
appendToEnd element list =
    List.reverse (element :: List.reverse list)


formatPostText : String -> String -> List (Element Style variation Msg)
formatPostText content boardName =
    let
        words =
            String.words content
    in
    List.map (\n -> parseQuote n boardName) words


parseQuote : String -> String -> Element Style variation Msg
parseQuote word boardName =
    let
        linkId =
            String.dropLeft 2 word |> String.toInt

        linkStart =
            String.contains ">>" word
    in
    if linkStart then
        case linkId of
            Ok postId ->
                link (postsPath boardName postId) <|
                    el Styles.PostLink
                        [ onLinkClick <| ChangeLocation (postsPath boardName postId) ]
                        (text <| word ++ " ")

            Err _ ->
                text <| word ++ " "
    else
        text <| word ++ " "