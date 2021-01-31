---
title: "Dactyl Tight Build"
date: 2021-01-30T16:18:11-08:00
draft: true
---

After reading about the
[tightyl](https://www.reddit.com/r/ErgoMechKeyboards/comments/glfsqh/i_present_the_tightyl_a_tight_tiny_dactyl_manuform/) on r/ergomechkeyboards, I decided to take the
plunge and build my own hand-wired keyboard. The total time to assemble it was
not as substantial as I expected, but there were some long gaps during the work
due to not having ordered some necessary parts.

## Parts

I've been using a [gergo](https://www.gboards.ca/product/gergo) for about a year
now, and decided that it would be nice to continue using a similar layout
keyboard, but with lighter keys. The layout that I use has a number of different
layers and a variant on home-row mods, so I am frequently pressing multiple keys
at once.  After doing some research, I settled on gateron clears, which are
linear and have a spring weight of 35g. I wasn't too sure about linear switches,
having only used tactile switches before, but thought that it would be worth an
experiment.

The case itself was printed locally by a friend, for the cost of one reel of
plastic. This worked out pretty well for me, as they have much more experience
with 3d printing than I do, and it would have been quite the detour into 3d
printing to get to the point where I could produce a nice print.

### Parts List

* [Both halves of the tightyl case](https://www.thingiverse.com/thing:4416866)
* 50 [gateron clear switches](https://flashquark.com/product/plate-mounted-gateron-switches/)
* 50 [clear translucent DSA keycaps](https://flashquark.com/product/translucent-dsa-keycaps/)
* 50 [black translucent DSA keycaps](https://flashquark.com/product/translucent-dsa-keycaps/)
* 100 [diodes](https://flashquark.com/product/1n4148-diodes/)
* 2 [arduino clone microcontrollers](https://www.amazon.com/gp/product/B07FXCTVQP)
* [dupont connector kit](https://www.amazon.com/gp/product/B07FXCTVQP)
* 100 heat set nuts
* 100 4mm M2.5 screws

## Assembly

I followed the technique outlined in [cribbit's modern handwiring
guide](https://geekhack.org/index.php?topic=87689.0). My wife had a set of
round-tipped needle nose pliers for jewelry making that worked really well for
wrapping the legs of the diodes into rings that would fit over the legs of the
switches. I purchased a [wire
stripper](https://www.amazon.com/gp/product/B0788K4R8Z) from amazon like the one
mentioned in the modern handwiring guide, and it really simplified the process
of stripping insulation from the solid core wire for the columns of the matrix.

For the connection to the microcontrollers I used a dupont connector kit from
amazon. The stranded wire was easy to thread under the matrix and solder to the
rows/columns, and the connectors fit well on the pins soldered to the
microcontroller. The result was that it was easy to remove the microcontroller
for debugging, which I needed to do plenty of when getting qmk setup.

## QMK Setup

I used the `util/new_keyboard.sh` script to create the initial configuration 
for the tightyl in `handwired/tightyl`. This script worked well, and the
configuration that it setup was a great starting point.

Getting the keyboard working took a bit of trial and error, though not with the
feature that I would have expected: I had a lot of trouble getting the
handedness detection working by setting one pin of the microcontroller high.
However, reading through the split keyboard documentation in QMK provides a lot
of options for handedness detection, and I ended up switching to using the
[unused
intersection](https://beta.docs.qmk.fm/using-qmk/hardware-features/feature_split_keyboard#handedness-by-matrix-pin)
in the keyboard matrix for identifying the left side of the keyboard.

The configuration that I've settled on is in my [qmk
fork](https://github.com/elliottt/qmk_firmware/tree/elliottt-config/keyboards/handwired/tightyl).
