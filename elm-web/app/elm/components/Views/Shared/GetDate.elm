module Views.Shared.GetDate exposing (getDate)

import Date exposing (Date)


getDate : String -> String
getDate date =
    case Date.fromString date of
        Ok date ->
            String.dropRight 1 (String.dropLeft 1 (toString date))

        Err _ ->
            ""
