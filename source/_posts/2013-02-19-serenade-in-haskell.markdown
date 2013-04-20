---
layout: post
title: "Serenade in Haskell"
date: 2013-04-12
comments: true
categories: [Haskell,Serenade]
published: false
---

One of the things that I think is great about Haskell is the way that you can
use the language to replicate what is in other languages, done via parsing and
processing.  After reading [a quick introduction to Serenade.js][serenade], one
of the features that caught my eye was their templating system.  It has a fairly
elegant interface, in which you don't really need to specify much information to
generate html, though it seemed like a heavyweight solution to me, as you end up
needing to roll a parser to implement it.

Upon closer inspection the examples provided seemed to be presenting a few key
combinators for constructing html.  After a bit of scaffolding, I'll demonstrate
my approach to replicating their examples in Haskell.  Just to be clear, this
isn't meant as a replacement, or a justification for templating in your source
language, but rather just an exploration of a Haskell embedding.

Preliminaries
-------------

```haskell
module Serenade where

import Text.PrettyPrint.HughesPJ
```

*If you don't already know the pretty package on hackage, it's worth learning.
Many of the unpleasant tasks of generating strings can be boiled down to elegant
uses of the combinators it provides.*

The type that the pretty package defines for pretty-printed documents is the
`Doc` type.  As I am going to be rendering out html in my `Serenade` type, it's
natural to make it an alias to the `Doc` type.

```haskell
type Serenade = Doc
```

I've simplified attributes a bit to key/value pairs, though it works well for my
small example.  Their pretty printing just involves printing the name as text,
followed by an '=' character, then the double quoted value.

```haskell
type Attr = (String,String)

attr :: Attr -> Serenade
attr (n,v) = text n <> char '=' <> doubleQuotes (text v)

attrs :: [Attr] -> Serenade
attrs  = hsep . map attr
```

Tags are implemented as functions from their attributes and a body document, to
a new document.  The `tag` primitive is a function that takes a boolean value
that specifies if its content should be nested, or on the same line, and the
name of the tag as a `String`.  When the resulting `Tag` is used, it prints out
open/close pairs of tags with their attributes, optionally placing the text
content of the tag on a new line.

There is currently no notion of a empty tag, such as `<br />`, though it would
be easy to generate that tag when the body argument was empty.

```haskell
type Tag = [Attr] -> Serenade -> Serenade

tag :: Bool -> String -> Tag
tag nl name as body =
     char '<' <> text name <+> attrs as <> char '>'
  ^^ nest 2 body
  ^^ text "</" <> text name <> char '>'
  where
  infixr 0 ^^
  (^^) | nl        = ($$)
       | otherwise = (<>)

```

Combinators
-----------

One of the thing that struck me about the Serenade templates was their
simplicity.  You don't have to write out the open/close tag pairs, and instead
just rely on layout to denote blocks.  Being a Haskell programmer, this just
seemed right.  Let's start by adding a few tag definitions so that the rest of
the examples have some motivation:

```haskell
ul, li, h1 :: Tag
ul = tag True  "ul"
li = tag False "li"
h1 = tag False "h1"
```

### Attributes

The first example that caught my eye was the difference between using a tag with
a list of attributes, and using a tag with a specific attribute, id.  There are
two flavors of syntax in Serenade to support this functionality, the most
general form first:

```
ul[id="x"] ...
ul#"x" ...
```

In the first example, you are just applying the `ul` tag to a list list of
attributes, whereas in the second example, you're using some special syntax to
set only the `id` attribute.  I've chosen to implement this as a function that
takes something a little more general than the `Tag` type specified above, as
there's no reason to rule out other uses of this pattern.

```haskell
(#) :: ([Attr] -> a) -> String -> a
k # i = k [("id", i)]

attr_example1 = ul [("id", "x")]
attr_example2 = ul # "x"
```

### Variables

In Serenade, variables are used by prefixing them with a `@` character.  For
example, if I have the `name` variable in scope, and would like to use it in the
body of an `li` tag, I can do this with the following snippet:

```
li Hello, my name is @name
```

The way that I might approach this in Haskell is to view `@` as something that
joins a piece of text with the value of a variable.  Assuming that all
variables in Serenade contain strings, this can be viewed as a combinator that
takes some `Serenade` thing on the left, and a variable that contains a `String`
on the right:

```haskell
(@@) :: Serenade -> String -> Serenade
l @@ r = l <> text r
```

Thus, the original example that uses the `li` tag can be turned into a function
that expects to have its `name` value provided.

```haskell
li_example :: String -> Serenade
li_example name = li [] ("Hello, my name is " @@name)
```

Modulo the extra `@` symbol to avoid the built-in use of `@` in Haskell, this
conveys the intent of the original serenade template.

### Collections

Serenade provides a way to, given a collection of key/value structures, run a
serenade template over each structure.

```
ul#comments
  - collection @comments
      li @title
```

As a Haskell programmer, this seems like the `map` function, but with a little
bit of extra information about how to put together the results.  The `vcat`
function from the pretty library covers how we'd like to join together the
documents generated from each element of the list, joining them together on
separate lines.  As a result, the Haskell implementation of the collection
function in Serenade should end up being just as powerful, as anything that you
can make into a `Serenade` thing, you can lift over lists.

```haskell
collection :: [a] -> (a -> Serenade) -> Serenade
collection as k = vcat (map k as)
```

Now, the example above can be encoded using the new `collection` combinator as
such, using the `text` function from the pretty library to turn the title string
into a Serenade document.

```haskell
col_example comments = ul # "comments"
                       $ collection comments
                       $ \title -> li [] (text title)
```

Ignoring the lambda, and the introduction of the comments as an argument to the
example, this looks quite similar to the example in the Serenade templating
language.

Conclusion
----------

[serenade]: http://elabs.se/blog/33-why-serenade
