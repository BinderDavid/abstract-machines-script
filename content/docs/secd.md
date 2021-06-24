---
title: "The SECD machine"
weight: 3
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The SECD machine

## Example Javascript embedding

Consider the grammar for arithmetic expressions, where `n` is a natural number.

```
tm ::= n
    | (tm + tm)
    | (tm * tm)
```

Every expression which corresponds to this grammar will generate a parsing tree, you can try
this out by typing in an expression below.

{{% embedelm %}}

## Further Reading

{{< hint info >}}
 * **Werner Kluge**, Abstract Computing Machines: A Lambda Calculus Perspective
   *(Chapter 5 is on (variants of) the SECD machine)*
{{< /hint >}}


