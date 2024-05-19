---
title: "Home Manager"
date: 2024-05-19T15:14:59-07:00
draft: false
tags: [nix]
---

I recently switched to managing my dotfiles with home-manager and nix, and have
slowly gone from trying to use it minimally to having it control a substantial
portion of my neovim configuration.

<!--more-->

## Dotfiles

My [dotfiles] repository has long been a disorganized collection of scripts and
config files that get symlinked in by whichever tool I happen to be using at the
time. For a while it used [rcm], but that required additional tools to be
installed before my dotfiles could be synced, and the capabilities of `rcup`
were a little lacking.

I switched to using [dotbot] after seeking out a slightly more structured tool,
which gave significantly more flexibility for modularizing my config. I used
[dotbot] as a git submodule, which meant that the tools I needed in order to
bootstrap a host were only git and python3. Still, this setup still meant that I
was using other tools to manage things like neovim plugins, and had implemented
yet another collection of shell scripts for managing individual host
configurations.

The [dotbot] config worked for a while, though after switching jobs and learning
that one of my coworkers was using nix to manage their home configuration, I
asked them to show me how all that worked. I was initially pretty skeptical, as
[home-manager] seemed like it wanted to manage things at a finer granularity
than I was comfortable with. For example, at the time I was using [oh-my-zsh] to
manage my zsh config. Switching to home-manager allowed for this, but changed
where the authoritative version of my `~/.zshrc` was.

I worked around this a bit by making as little use of [home-manager]'s builtin
configuration for programs that I relied on, but it soon became obvious that I
was missing out. For example, using `eza` and having [home-manager] install all
the aliases necessary to use it transparently as `ls` is really convenient, and
you don't get that if you're still trying to keep your shell config out of
`home.nix`.

## Neovim

This same sort of problem came into focus more recently, when I went to change
from using the now unmaintained [packer.nvim] for [lazy.nvim]. As the locations
for all the plugins I had installed had changed, many needed to be rebuilt. One
that I wrote for managing markdown files ([two-trucs]) needs to build a rust
binary that's used for filtering buffers. In the past this was fine as I would
use [rustup] to manage my rust toolchain, and it would always be available in my
current environment. With home-manager though, I had started relying on
per-project development environment configurations, and as an effect had been
keeping the rust toolchain out of my default environment.

As I was now unable to build a plugin that I relied on for managing notes
throughout the workday, I decided to take the plunge and switch my neovim plugin
configuration over to being specified in my home-manager configuration. This
would mean that I could depend on [two-trucs] as a flake input to my dotfiles'
flake.nix, and build the rust binary in my neovim config. Concretely, the change
to my `flake.nix` looked like the following:

I added the [two-trucs] repository to the `inputs` section of `flake.nix`, and
added the `extraSpecialArgs` option to my home-manager config function:

```nix
{
  description = "elliottt's home-manager configuration";

  inputs = {
  ...
    two-trucs = {
      url = "github:elliottt/two-trucs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, two-trucs, ... }: {
    let

      mkHostConfig = cfg:
        let

          pkgs = import nixpkgs {
            system = cfg.system or "x86_64-linux";
            overlays = [ nixgl.overlay ];
          };

        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit two-trucs; };
          modules = [
            cfg.home
            ./home.nix
          ];
        };

    in {
      homeConfigurations = {
        "trevor@badtz-maru" = mkConfig {
          home = ./hosts/badtz-maru.nix;
        };
        ...
      };
    };
  };
}

```

After this change, I was able to start relying on the `two-trucs` argument being
present in my neovim home-manager module. I modified it to build the binary, and
produce a vim plugin that could be used as input to `programs.neovim.plugins`
option in my home-manager config:

```nix
{ pkgs, two-trucs, ... }:

let
  two-trucs-bin = pkgs.rustPlatform.buildRustPackage rec {
    name = "two-trucs";
    version = "0.1.0";
    src = two-trucs;
    doCheck = false;
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };
  };

  two-trucs-nvim-pkg = pkgs.vimUtils.buildVimPlugin {
    name = "two-trucs";
    version = "0.1.0";
    src = two-trucs;
    buildInputs = [ two-trucs-bin ];
    buildPhase = ''
      mkdir -p "$out/bin"

      ln -s "${two-trucs-bin}/bin/two-trucs" "$out/bin/two-trucs"
    '';
  };

in

{
...
  programs.neovim.plugins = [
    two-trucs-nvim-pkg
  ];
...
}
```

Initially I tried to continue using [lazy.nvim] for all other plugins, only
relying on nix for the built version of [two-trucs]. However, I quickly ran into
problems, as [lazy.nvim] will take over the `rtp` variable in neovim, and broke
the search path that included my nix-managed version of [two-trucs]. I
begrudgingly gave up on using [lazy.nvim] for pluging management, and it turned
out to be a great change: I could now depend on packaged versions of plugins
that had previously caused me some trouble during updates (`treesitter`,
`telescope-fzf-native`, etc).

## Conclusions

More of my dotfiles config has been creeping into nix after my switch to using
home-manager. While I was initially pretty hesitant to move more config into
home-manager, it seems to be paying off by simplifying my default environment,
and making updates easier. While nix and home-manager have been working really
well for me recently, I'm not sure that I could recommend that anyone else
follow this same path, as much of the tooling is under-documented, and current
best-practices are really hard to discover.

[dotfiles]: https://github.com/elliottt/dotfiles
[rcm]: https://github.com/thoughtbot/rcm
[dotbot]: https://github.com/anishathalye/dotbot
[home-manager]: https://github.com/nix-community/home-manager
[oh-my-zsh]: https://ohmyz.sh
[packer.nvim]: https://github.com/wbthomason/packer.nvim
[lazy.nvim]: https://github.com/folke/lazy.nvim
[two-trucs]: https://github.com/elliottt/two-trucs
[rustup]: https://rustup.rs
