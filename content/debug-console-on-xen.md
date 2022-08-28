---
title: Debug Console on Xen
date: 2015-03-04
tags: [xen,halvm]
---

When debugging [HaLVM](http://halvm.org) domains, the `writeDebugConsole`
function from `Hypervisor.Debug` is invaluable.  However, in order to see the
messages printed, you must enable the emergency console in
[Xen](http://xen.org).  This isn't too difficult, but it's not terribly well
documented: there are many sources that describe parts of the process, but none
that describe the whole thing.

<!--more-->

Rebuilding Xen
--------------

First, Xen must be rebuilt with the emergency console enabled.  This is a
relatively simple step, especially if you're building rpms.  When running
`make`, make sure to add the additional argument `verbose=y`, which enables the
emergency console.  If rebuilding an rpm, just modify the `make` invocation in
the `%build` section of the spec file.

```sh
$ make verbose=y
```

Booting Xen
-----------

Next, you will need to modify the command line passed to Xen on boot,
instructing it to output messages to the debug console.  When using grub2, on
Fedora, this is achieved by modifying the `/etc/default/grub` file, and
rebuilding the grub configuration.

First, append this line to `/etc/default/grub`:

```sh
GRUB_CMDLINE_XEN="loglvl=all guest_loglvl=all sync_console console_to_ring"
```

This sets the logging level of both Xen and any guest domains to all, forces
synchronous output to the console, and copies all guest console output to the
console ring buffer.

Next, run this command to regenerate your grub config:

```sh
$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

Now, you should be able to just reboot, selecting Xen from the grub menu, and be
able to see the output of calls to `writeDebugConsole`.

Wrapping Up
-----------

You should now be able to rebuild and configure Xen to allow guest domains to
write to the emergency console.  In particular, you can use this new feature to
aid the debugging of HaLVM domains.
