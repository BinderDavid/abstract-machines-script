---
title: "Lambda Calculus"
weight: 2
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The Lambda Calculus

We will briefly review the basics of the lambda calculus. We will use this section to establish a common vocabulary for the following sections, and in order to ensure that everyone is on the same page.

## Syntax

The terms of the lambda calculus consist of only three constructs; variables `x`, the application of one lambda term to another lambda term `(t t)` and lambda abstractions `\x. t`.

```bnf
t ::= x
    | (t t)
    | \x. t
```

We can encode this in Haskell as:

```haskell
type Name = String
data Term = TmVar Name
          | TmApp Term Term
          | TmAbs Name Term
```

## Renaming of bound variables

```bnf
\x. x = \y. y
```

## Beta-reduction

What turns the lambda calculus into a primitive programming language is the fact that we can reduce lambda terms.
A reducible expression, or *redex* for short, is any lambda term of the following form:

```bnf
(\x. s) t
```

## Confluence

One of the most important properties of the lambda calculus is *confluence*, also called the *Church-Rosser property* or the *diamond property*.

## Further Reading

{{< hint info >}}
 * **J.R.Hindley and J.P. Seldin**, Lambda-Calculus and Combinators: An Introduction
   *(An introductory textbook for the untyped and typed lambda calculus, as well as combinatory logic)*
 * **H. Barendregt**, The Lambda Calculus, its Syntax and Semantics
   *(This is the definitive reference for the untyped lambda calculus, not for the faint of heart)*
{{< /hint >}}
