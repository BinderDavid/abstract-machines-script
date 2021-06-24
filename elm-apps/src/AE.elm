module AE exposing (..)

import Parser as P exposing (Parser, (|=), (|.), spaces, symbol, succeed, oneOf, andThen, lazy)
import String exposing (fromInt)
import TreeView exposing (..)
import Html exposing (..)

type AE_Term
    = AE_Int Int
    | AE_Add AE_Term AE_Term
    | AE_Mult AE_Term AE_Term

-- Parser

parse : String -> Result (List P.DeadEnd) AE_Term
parse str = P.run ae_termP str

ae_termP : Parser AE_Term
ae_termP = succeed identity
         |. spaces
         |= oneOf
            [ ae_intP
            , lazy (\_ -> P.backtrackable ae_addP)
            , lazy (\_ -> ae_multP)
            ]

ae_intP : Parser AE_Term
ae_intP = P.int |> P.map (\i -> AE_Int i)

ae_addP : Parser AE_Term
ae_addP = succeed AE_Add
        |. symbol "("
        |= ae_termP
        |. spaces
        |. symbol "+"
        |= ae_termP
        |. spaces
        |. symbol ")"
        |. spaces


ae_multP : Parser AE_Term
ae_multP = succeed AE_Mult
        |. symbol "("
        |= ae_termP
        |. spaces
        |. symbol "*"
        |= ae_termP
        |. spaces
        |. symbol ")"
        |. spaces

-- Prettyprinter

showTerm : AE_Term -> String
showTerm t = case t of
                   AE_Int i -> fromInt i
                   AE_Add t1 t2 -> "(" ++ showTerm t1 ++ "+" ++ showTerm t2 ++ ")"
                   AE_Mult t1 t2 ->  "(" ++ showTerm t1 ++ "*" ++ showTerm t2 ++ ")"


-- Evaluation

type Value
    = ValInt Int
    | ValError String

showValue : Value -> String
showValue v = case v of
                  ValInt i -> fromInt i
                  ValError err -> "Error: " ++ err

eval : AE_Term -> Value
eval tm = case tm of
              AE_Int i -> ValInt i
              AE_Add tm1 tm2 -> case eval tm1 of
                                    ValInt i1 -> case eval tm2 of
                                                     ValInt i2 -> ValInt (i1 + i2)
                                                     ValError err -> ValError err
                                    ValError err -> ValError err
              AE_Mult tm1 tm2 -> case eval tm1 of
                                    ValInt i1 -> case eval tm2 of
                                                     ValInt i2 -> ValInt (i1 * i2)
                                                     ValError err -> ValError err
                                    ValError err -> ValError err

-- AST Tree

toTree : AE_Term -> DerivTree AE_Term String
toTree tm = case tm of
                AE_Int i -> Node [] tm "Int"
                AE_Add tm1 tm2 -> Node [toTree tm1, toTree tm2] tm "Add"
                AE_Mult tm1 tm2 -> Node [toTree tm1, toTree tm2] tm "Mult"


renderAST : DerivTree AE_Term String -> Html msg
renderAST tree = render tree (\tm -> text ("$$ " ++ (showTerm tm) ++ " \\in \\mathit{Tm} $$")) (\label -> text label)


