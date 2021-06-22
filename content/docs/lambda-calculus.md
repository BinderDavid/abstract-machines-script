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

```
t ::= x
    | (t t)
    | \x. t
```

Some examples of lambda terms, together with their name, are:

 * `\x. x` The identity function *id* which just returns its argument.
 * `\x. \y. x` The constant function *const* which ignores its second argument.
 * `(\x. x x)(\x. x x)` The diverging term *omega*. This term cannot be reduced to normal form.

## Renaming of bound variables

```
\x. x = \y. y
```

## Beta-reduction

What turns the lambda calculus into a primitive programming language is the fact that we can reduce lambda terms.
A reducible expression, or *redex* for short, is any lambda term of the following form:

```
(\x. s) t
```

We can replace this redex by its *reduct*, where we replace every bound occurrence of `x` in `s` by `t`:

```
s[t/x]
```

If `t` is a closed term, this is not a problem.
If, on the other hand, `t` contains free variables, then we have to ensure that we do not accidentally capture these free variables.

## Confluence

One of the most important properties of the lambda calculus is *confluence*, also called the *Church-Rosser property* or the *diamond property*.

## Further Reading

{{< hint info >}}
 * **J.R.Hindley and J.P. Seldin**, Lambda-Calculus and Combinators: An Introduction
   *(An introductory textbook for the untyped and typed lambda calculus, as well as combinatory logic)*
 * **H. Barendregt**, The Lambda Calculus, its Syntax and Semantics
   *(This is the definitive reference for the untyped lambda calculus, not for the faint of heart)*
{{< /hint >}}
