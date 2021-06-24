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

render : DerivTree a b
       -> (a -> Html msg) -- How to render judgements.
       -> (b -> Html msg) -- How to render rule labels.
       -> Html msg
render (Node premisses conclusion label) renderJudgement renderLabel =
    table [] [ tr [] (List.append
                          (List.map (\premis -> td [] [render premis renderJudgement renderLabel]) premisses)
                          [td [class "rulename", rowspan 2] [div [class "rulename"][renderLabel label]]])
             , tr [] [td [class "conc"] [renderJudgement conclusion]]
             ]

--Debug.todo "implement"

 -- <table>
 --                <tr>
 --                    <td></td>
 --                    <td class="rulename" rowspan="2">
 --                        <div class="rulename">const</div>
 --                    </td>
 --                </tr>
 --                <tr>
 --                    <td class="conc">&#x393;&#x022A2;1:&#x3C4;</td>
 --                </tr>
 -- </table>

