---
title: Vim Mapping Context
date: 2013-02-22
tags: [vim]
---

If you're like me, you've got a lot of filetype-specific macros defined in your
vim config.  I tend to put these in `$VIM/after/syntax` so that I can keep it
all self-contained, but up until recently, macros had been bleeding into
different filetype contexts.  The problem was that I had been installing all
macros into the global scope, instead of the buffer scope, like this:

<!--more-->

```vim
nmap <LocalLeader>l ...
```

Luckily, vim has a provision for this, and adding `<buffer>` right after the use
of `nmap` fixes the problem, and keeps the mapping buffer-local:

```vim
nmap <buffer> <LocalLeader>l ...
```
