---
layout: post
title: "Vim Register Trick"
date: 2013-02-19 11:06
comments: true
categories: vim
---
Well, it's new to me.

When you type `C-r` in edit mode, you get the opportunity to recall the contents
of a register.  While I had known about this, I never thought to apply it when
doing search and replace.  For example, if you search for something using `*`,
then want to replace what you've found with something else, you can type:

```vim
:%s/C-r//replacement/g
```

The contents of your last search will magically show up when you type the `/`
character, and your days of trying to remember the pattern for the last thing
you searched for are over!
