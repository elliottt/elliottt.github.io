---
title: Vim's `findfile` function
publishDate: "2016-08-27"
tags: [vim]
---

I've recently updated the tests for `stack.yaml` and `cabal.project` files in my
[vim haskell plugin](https://github.com/elliottt/vim-haskell). The
`haskell#StackYamlFileExists` and `haskell#CabalProjectFileExists` functions now
take advantage of vim's `findfile` function for searching up the directory tree,
rather than just require that either file exist in the current working
directory. This change makes a bit more sense given the way that both `stack`
and `cabal new-build` work, allowing the commands to be invoked from anywhere
underneath the directory that contains `stack.yaml` or `cabal.project`.

<!--more-->

The `findfile` function is quite handy for this situation, as it's able to
search up as well as down the directory tree. Simply specifying the directory to
search from as `'.;'` instructs it to search up the tree, and passing the
`{list}` argument as `-1` returns a list of the matches instead of the path of
the first match.

I've now updated my
[personal haskell config](https://github.com/elliottt/vim-config/blob/master/after/syntax/haskell.vim)
to choose which tool to use, based on the three predicates that the plugin
provides:

```vim
" Configure :make
if haskell#CabalProjectFileExists()
    compiler cabal-new-build
elseif haskell#StackYamlFileExists()
    compiler stack-build
elseif haskell#CabalFileExists()
    compiler cabal-build
endif
```
