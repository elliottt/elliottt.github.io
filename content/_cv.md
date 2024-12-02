---
title: trevor elliott
url: /cv/
_build:
  list: "never"
---

A [PDF resume](resume.pdf) is also available.

Over a decade of experience applying functional programming to hard problems:
program analysis, cyber-security, and language design.

# Work Experience

## Stripe - October 2024 - Present
**Infrastructure Engineer** - Working on the [sorbet] typechecker for ruby.

## Fastly - May 2022 - October 2024
**Principal Engineer** - Working on the wasm team, contributing to a variety of
projects centered around the running of WebAssembly
* Contributor to wasamtime and the cranelift code generator
* Contributor to the js-compute-sdk, as well as the viceroy local testing
  environment
* Helped with the implementation and specification of wasi-preview2, and
  wasi-http
* Participated in the RFC process for wasmtime to help set the direction for
  debugging

## Stripe - April 2019 - May 2022
**Infrastructure Engineer** - Worked on the [sorbet] typechecker and compiler
for ruby.
* Key contributor on the sorbet compiler, implemented optimizations and improved
  coverage for the ruby language. Generated native code with llvm, targeting the
  ruby vm's c api.
* Implemented type-system features, and improved type-checker runtime
  performance.
* Mentored an intern on the sorbet compiler project, and organized/ran regular
  meetings with external contributors from other companies.

## groq, inc. Sept 2017 - March 2019
**Compiler Engineer** - Worked on a compiler for tensorflow models,
targeting a custom ASIC that accelerates inference. Focused on compiler
performance and optimization of results.

## Galois, Inc. - Sept 2007 - Sept 2017
**Member of the technical staff** - Contributed to a broad range of projects,
notably:
* Developed domain specific languages in Haskell, including the
  [msf-haskell] metasploit DSL and the [ivory] DSL for memory-safe
  embedded programming
* Developed and contributed to multiple full language implementations,
  including [cryptol] and the [salty] GR(1) reactive synthesis DSL
* Implemented the [hans] network stack
* Aided ASIC design and verification for lightweight cryptographic
  primitives from Cryptol specifications

## CollegeNET, July 2004 - September 2007
**Developer** - Helped to transition a large desktop application to a suite of
web services, and developed tools based off of those web services. Also
assisted with some front-end web development, and implemented an LDAP-based
authentication system.

## CollegeNET, July 2002 - July 2004
**Technical Support** - Provided technical support to a large client base.

---

# Education

## **BS, Computer Science**, December 2008
Portland State University, Portland, OR

---

# Technologies

**Languages** - haskell, c/c++, ruby, rust, java, javascript, fsharp, ocaml,
python, coq, isabelle/hol, shell scripting, assembly (x86, arm)

**Tools** - git, gnu make, vim/neovim, bazel, z3, smt-lib, gdb, lldb


---

# Research Projects

* [cryptol] **Maintainer and contributor**  
  Domain specific language for aiding implementation and verification of
  cryptographic algorithms.
* [ivory] **Lead engineer**  
  Haskell EDSL for memory-safe embedded programming.
* [salty] **Lead engineer**  
  Reactive synthesis DSL for GR(1) specifications.
* [msf-haskell] **Lead engineer**  
  Haskell EDSL for interacting with the metasploit framework.
* [hans] **Lead engineer**  
  A TCP/IP network stack implemented in haskell.
* [halvm] **Contributor**  
  Port of the GHC runtime to the Xen hypervisor.

---

# Open Source Projects

- [sorbet]  
  The Sorbet typechecker for ruby.
- [cereal]  
  Binary format parsing library
- [llvm-pretty]  
  An EDSL for generating textual llvm bitcode.
- [llvm-pretty-bc-parser]  
  A parser for the llvm binary bitcode format.
- [huff]  
  A fast-forward based classical planning EDSL.
- [pretty]  
  Contributed support for document annotations.

---

# Publications and Talks

## November 2021

### Compiling Ruby to Native Code with Sorbet
RubyConf 2021, introducing the Sorbet compiler, and discussing the background of
the proect at Stripe. [talk][sorbet2021]

## May 2019

### Salty-A Domain Specific Language for GR(1) Specifications and Designs
Salty is a domain specific language for GR(1) specifications. It makes it
easier to write and debug specifications by adding richer types to the
specification language, user-defined macros, specification optimizations, and
type-checking. [ieee][salty-ieee]

## September 2016

### TrackOS: A security-aware real-time operating system, RV.
Introduces the TrackOS embedded operating system. TrackOS allows for run-time
monitoring of control flow for running tasks, with a control flow graph that is
established during a post-processing pass that doesn't require access to source
code. [paper](trackos-rv16.pdf)

## August 2015

### Guilt Free Ivory
Describes the implementation of the Ivory domain specific language in Haskell,
as well as the static guarantees that the language provides.
[paper](ivory.pdf), [talk][ivory2015-talk]

## December 2014

### Multi-App Security Analysis with FUSE
Introduces the FUSE system, which is used to detect collusion between android
apps installed on the same phone. [paper](2014_ravitch2014multi.pdf)

## November 2014

### Programming Languages for High-Assurance Autonomous Vehicles
Introduces domain specific languages as a means for programmer productivity, in
the realm of programming for autonomous vehicles. [paper](pike-plpv14.pdf)

## August 2014

### Building Embedded Systems with Embedded DSLs, ICFP
An experience report detailing the development of the [smaccmpilot] autopilot in
the Ivory and Tower Haskell EDSLs. At the time, [smaccmpilot] comprised 10K
lines of haskell, and generated about 50K lines of C.
[paper](embedded-experience.pdf)

## September 2010

### Concurrent Orchestration in Haskell, Haskell Sympmosium
Describes the embedding of the [orc] orchestration language as the [haskell orc]
library. [acm][orc-acm]



[cryptol]: https://cryptol.net "Cryptol"
[salty]: https://github.com/galoisinc/salty "Salty"
[salty-ieee]: https://ieeexplore.ieee.org/document/8793722
[ivory]: https://ivorylang.org "Ivory"
[ivory2015-talk]: https://www.youtube.com/watch?v=D1rm5SnvmKE "Guilt Free Ivory"
[msf-haskell]: https://github.com/galoisinc/msf-haskell "MSF-Haskell"
[hans]: https://github.com/galoisinc/hans "HaNS"
[halvm]: https://github.com/galoisinc/halvm "HaLVM"
[cereal]: https://github.com/galoisinc/cereal "cereal"
[llvm-pretty]: https://github.com/galoisinc/llvm-pretty "llvm-pretty"
[llvm-pretty-bc-parser]: https://github.com/galoisinc/llvm-pretty-bc-parser
[huff]: https://github.com/elliottt/huff "huff"
[pretty]: https://github.com/haskell/pretty "pretty"
[smaccmpilot]: https://smaccmpilot.org/ "SMACCMPilot"
[haskell orc]: https://hackage.haskell.org/package/orc "Orc"
[orc]: http://orc.csres.utexas.edu/research.shtml "Orc"
[orc-acm]: https://dl.acm.org/doi/10.1145/1863523.1863534
[sorbet]: https://sorbet.org "Sorbet"
[sorbet2021]: https://www.youtube.com/watch?v=BH8S1htcHXY "Compiling Ruby to Native Code with Sorbet & LLVM"
[fuse-paper]: http://lilicoding.github.io/SA3Repo/papers/2014_ravitch2014multi.pdf
