module AE exposing (..)

import Parser as P exposing (Parser, (|=), (|.), spaces, symbol, succeed, oneOf, andThen, lazy)
import String exposing (fromInt)
import TreeView exposing (..)
import Html exposing (..)

type Term
    = T
    | F
    | Zero
    | Succ Term
    | Pred Term
    | IsZero Term
    | IfExpr Term Term Term

-- Parser

parse : String -> Result (List P.DeadEnd) Term
parse str = P.run term str

term : Parser Term
term = succeed identity
       |. spaces
       |= oneOf
          [ true
          , false
          , zero
          , succ
          , pred
          , isZero
          , lazy (\_ -> ifExpr)
          ]

true : Parser Term
true = succeed T |. symbol "true"

false : Parser Term
false = succeed F |. symbol "false"

zero : Parser Term
zero = succeed Zero |. symbol "zero"

succ : Parser Term
succ = symbol "succ"
     |> andThen (\_ -> term)
     |> P.map (\t -> Succ t)

pred : Parser Term
pred = symbol "pred"
     |> andThen (\_ -> term)
     |> P.map (\t -> Pred t)

isZero : Parser Term
isZero = symbol "isZero"
     |> andThen (\_ -> term)
     |> P.map (\t -> IsZero t)

ifExpr : Parser Term
ifExpr =
    succeed IfExpr
        |. symbol "if"
        |= term
        |. spaces
        |. symbol "then"
        |= term
        |. spaces
        |. symbol "else"
        |= term

-- Prettyprinter

showTerm : Term -> String
showTerm t = case t of
                 T -> "true"
                 F -> "false"
                 Zero -> "zero"
                 Succ s -> "succ " ++ showTerm s
                 Pred s -> "pred " ++ showTerm s
                 IsZero s -> "isZero " ++ showTerm s
                 IfExpr s p q -> "if " ++ showTerm s ++ " then " ++ showTerm p ++ " else " ++ showTerm q

-- Evaluation

type Value
    = ValBool Bool
    | ValInt Int
    | ValError String

showValue : Value -> String
showValue v = case v of
                  ValBool True -> "true"
                  ValBool False -> "false"
                  ValInt i -> fromInt i
                  ValError err -> "Error: " ++ err

eval : Term -> Value
eval tm = case tm of
              T -> ValBool True
              F -> ValBool False
              Zero -> ValInt 0
              Succ tm2 -> case eval tm2 of
                              ValInt i -> ValInt (i + 1)
                              _ -> ValError "Applied Succ to non-int value"
              Pred tm2 -> case eval tm2 of
                              ValInt i -> ValInt (i - 1)
                              _ -> ValError "Applied Pred to non-int value"
              IsZero tm2 -> case eval tm2 of
                                ValInt i -> if i == 0 then ValBool True else ValBool False
                                _ -> ValError "Applied IsZero to non-int value"
              IfExpr tm2 tm3 tm4 -> case eval tm2 of
                                        ValBool True -> eval tm3
                                        ValBool False -> eval tm4
                                        _ -> ValError "Applied IfExpr to non-bool value"


-- AST Tree

toTree : Term -> DerivTree Term String
toTree tm = case tm of
                T -> Node [] tm "T"
                F -> Node [] tm "F"
                Zero -> Node [] tm "Zero"
                (Succ tm2) -> Node [toTree tm2] tm "Succ"
                (Pred tm2) -> Node [toTree tm2] tm "Pred"
                (IsZero tm2) -> Node [toTree tm2] tm "IsZero"
                (IfExpr tm2 tm3 tm4) -> Node [toTree tm2, toTree tm3, toTree tm4] tm "If"


renderAST : DerivTree Term String -> Html msg
renderAST tree = render tree (\tm -> text (showTerm tm)) (\label -> text label)
