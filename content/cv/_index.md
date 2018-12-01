+++
title = "cv"
+++

For the past decade or so, I've been applying functional programming to various
problems, from high-level language design to network stack and OS
implementation.

# Work Experience

## groq, inc. Sept 2017 - Present
**Compiler Engineer** - Developing a compiler for tensorflow models targeting a
custom ASIC for accelerating inference.

## Galois, Inc. - Sept 2007 - Sept 2017
**Member of the technical staff** - Contributed to a broad range of projects.
Developed domain specific languages in Haskell for a number of different
domains. Worked on multiple full language implementations, including [cryptol],
and the [salty] reactive synthesis DSL.

## CollegeNET, July 2004 - September 2007
**Developer** - Helped to transition a desktop application to a suite of web
services, and developed tools based off of those web services. Assisted with
some front-end web development.

## CollegeNET, July 2002 - July 2004
**Technical Support** - Provided support for a desktop application to a large
client base.

---

# Education

## **BS, Computer Science**, December 2008
Portland State University, Portland, OR

---

# Skills

## Programming Languages
haskell, rust, fsharp, c/c++, java, javascript, python, ruby, assemble (x86,
arm), coq, isabelle/hol, shell scripting

## Tools
z3, smt-lib, gdb, gnu make, apache ant, vim/neovim


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

# Publications

## September 2016

### TrackOS: A security-aware real-time operating system, RV.
Introduces the TrackOS embedded operating system. TrackOS allows for run-time
monitoring of control flow for running tasks, with a control flow graph that is
established during a post-processing pass that doesn't require access to source
code.

## August 2015

### Guilt Free Ivory, Haskell Symposium
Describes the implementation of the Ivory domain specific language in Haskell,
as well as the static guarantees that the language provides.

## December 2014

### Multi-App Security Analysis with FUSE: Statically Detecting Android App Collusion, PPREW
Introduces the FUSE system, which is used to detect collusion between android
apps installed on the same phone.

## November 2014

### Programming Languages for High-Assurance Autonomous Vehicles, PLPV
Introduces domain specific languages as a means for programmer productivity, in
the realm of programming for autonomous vehicles.

## August 2014

### Building Embedded Systems with Embedded DSLs, ICFP
An experience report detailing the development of the [smaccmpilot] autopilot in
the Ivory and Tower Haskell EDSLs. At the time, [smaccmpilot] comprised 10K
lines of haskell, and generated about 50K lines of C.

## September 2010

### Concurrent Orchestration in Haskell, Haskell Sympmosium
Describes the embedding of the [orc] orchestration language as the [haskell orc]
library.



[cryptol]: https://cryptol.net "Cryptol"
[salty]: https://github.com/galoisinc/salty "Salty"
[ivory]: https://ivorylang.org "Ivory"
[msf-haskell]: https://github.com/galoisinc/msf-haskell "MSF-Haskell"
[hans]: https://github.com/galoisinc/hans "HaNS"
[halvm]: https://halvm.org "HaLVM"
[cereal]: https://github.com/galoisinc/cereal "cereal"
[llvm-pretty]: https://github.com/elliottt/llvm-pretty "llvm-pretty"
[llvm-pretty-bc-parser]: https://github.com/galoisinc/llvm-pretty-bc-parser
[huff]: https://github.com/elliottt/huff "huff"
[pretty]: https://github.com/haskell/pretty "pretty"
[smaccmpilot]: https://smaccmpilot.org/ "SMACCMPilot"
[haskell orc]: https://hackage.haskell.org/package/orc "Orc"
[orc]: http://orc.csres.utexas.edu/research.shtml "Orc"
