module AE exposing (..)

import Parser as P exposing (Parser, (|=), (|.), spaces, symbol, succeed, oneOf, andThen, lazy)

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
