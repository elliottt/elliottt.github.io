---
layout: post
title: "Serenade in Haskell"
date: 2013-02-19 14:12
comments: true
categories: [Haskell,Serenade]
published: false
---

```haskell
module Serenade where
```
One of the things that I think is great about Haskell is the way that you can
use the language to replicate what is in other languages, done via parsing and
processing.  After reading a quick introduction to Serenade.js
(http://elabs.se/blog/33-why-serenade), one of the features that caught my eye
was their templating system.  It has a fairly elegant interface, in which you
don't really need to specify much information to generate html, though it seemed
like a heavyweight solution to me, as you end up needing to roll a parser to
implement it.

Upon closer inspection the examples provided seemed to be presenting a few key
combinators for constructing html.  After a bit of scaffolding, I'll demonstrate
my approach to replicating their examples in Haskell.  Just to be clear, this
isn't meant as a replacement, or a justification for templating in your source
language, but rather just an exploration of a Haskell embedding.

```haskell
import Text.PrettyPrint.HughesPJ
```

If you don't already know the pretty package on hackage, it's worth learning.
Many of the unpleasant tasks of generating strings can be boiled down to elegant
uses of the combinators it provides.

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

And now for the Serenade combinators.  One of the thing that struck me about the
Serenade templates was their simplicity.  You don't have to write out the
open/close tag pairs, and instead just rely on layout to denote blocks.  Being a
Haskell programmer, this just seemed right.  Let's start by adding a few tag
definitions so that the rest of the examples have some motivation:

```haskell
ul, li, h1 :: Tag
ul = tag True  "ul"
li = tag False "li"
h1 = tag False "h1"
```

The first example that caught my eye was the difference between using a tag with
a list of attributes, and using a tag with a specific attribute, id.  There are
two flavors of syntax in Serenade to support this functionality, the general
form first:

```
ul[id="x"] ...
ul#"x" ...
```

To me, this just screams for a combinator.  In the first example, you are just
applying the list of attributes to the `ul` tag, whereas in the second example,
you're using some special syntax to denote the specific attribute that you want.
I've chosen to implement this as a function that takes something a little more
general than the `Tag` type specified above, as there's no reason to rule out
other uses of this pattern.

```haskell
(#) :: ([Attr] -> a) -> String -> a
k # i = k [("id", i)]
```

In Serenade, variables are used by prefixing them with a `@` character.  For
example, if I have the `name` variable in scope, and would like to use it in the
body of an `li` tag, I can do this with the following snippet:

```
li Hello, my name is @name
```

The way that I might approach this in Haskell is to view `@` as something that
joins a piece of text with the content of a variable.  Assuming that all
variables in Serenade are strings, this can be viewed as a combinator that takes
some `Serenade` thing on the left, and a variable that contains a `String` on
the right:

```haskell
(@@) :: Serenade -> String -> Serenade
l @@ r = l <> text r
```

Thus, the original example that uses the `li` tag can be turned into something
that looks like a function:

```haskell
li_example :: String -> Serenade
li_example name = li [] ("Hello, my name is " @@name)
```

Modulo the extra `@` symbol to avoid the built-in use of `@` in Haskell, I feel
like this is fairly close to the intent of the original template.

```haskell
collection :: [a] -> (a -> Serenade) -> Serenade
collection as k = vcat (map k as)
```

```haskell
example1 name = h1 [("title",name)] (text "His name is " @@ name)
example2 col  = ul # "comments" $ collection $ li [] . text
```
