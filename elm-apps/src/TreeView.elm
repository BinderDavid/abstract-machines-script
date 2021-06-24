module TreeView exposing (..)

import Maybe
import Html exposing (Html, button, div, text, input, table, td, tr)
import Html.Attributes exposing (class, rowspan)

-- A DerivTree a b is a derivation in natural deduction style, using "a" as judgements, and "b" as rule labels.
-- A DerivTree is implemented as a RoseTree
type DerivTree a b
    = Node (List (DerivTree a b)) a b

depth : DerivTree a b -> Int
depth t = case t of
              Node xs _ _ -> Maybe.withDefault 0 (List.maximum (List.map depth xs))




-- Adapted the solution by user "CSSProof" on stackoverflow:
-- https://stackoverflow.com/questions/16212364/how-do-i-display-a-proof-tree-with-html-css-and-or-javascript 
render : DerivTree a b
       -> (a -> Html msg) -- How to render judgements.
       -> (b -> Html msg) -- How to render rule labels.
       -> Html msg
render (Node premisses conclusion label) renderJudgement renderLabel =
    div [class "proof"]
        [ div [class "prems"] (List.intersperse
                                   (div [class "inter-proof"][])
                                   (List.map (\premis -> render premis renderJudgement renderLabel) premisses))
        , div [class "concl"] [ div [class "concl-left"] []
                              , div [class "concl-center"] [renderJudgement conclusion]
                              , div [class "concl-right"] []
                              ]
        ]

