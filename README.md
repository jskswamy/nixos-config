# nixos-config

## What is Nix?

Nix is a reproducible package manager and build system. It installs software into content-addressed, immutable store
paths and composes systems declaratively from those building blocks. Because builds are pure and isolated, the same
configuration yields the same result on any machine.

### nix-darwin

nix-darwin brings Nix-style, declarative configuration to macOS. It manages macOS system defaults,
LaunchDaemons/Agents, system packages, and more using Nix.

### Home Manager

Home Manager manages per-user dotfiles and CLI tools declaratively (shells, editors, prompts, aliases, etc.) and
works on both macOS and Linux. It pairs well with nix-darwin (macOS) and NixOS (Linux).

## Why a single, consolidated configuration?

Running macOS and Linux with a mix of system-level (nix-darwin/NixOS) and user-level (Home Manager) configuration
can get fragmented. A single flake unifies:

- nix-darwin/NixOS system configuration
- Home Manager user programs and dotfiles
- Shared modules and overlays across platforms

This repository follows the approach popularized by the excellent base repo:
[dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config). Refer there for deeper background, rationale,
and additional tips.

## About this repo

This is my new home configuration and replaces my previous setup at
[jskswamy/nix-darwin](https://github.com/jskswamy/nix-darwin). It consolidates macOS and NixOS into one flake with
shared modules and per-host overrides.

## Setup guide

1. Install Nix

- Follow the official instructions: [Install Nix](https://nixos.org/download)

1. Clone this repo

```bash
git clone https://github.com/jskswamy/nixos-config
cd nixos-config
```

1. (Optional) Personalize templates

- Replaces tokens like `%USER%`, `%EMAIL%`, `%NAME%` in the tree.

```bash
nix run .#apply
```

1. Build and switch

- macOS (Apple Silicon example):

```bash
nix run .#build-switch                 # builds then switches
# or directly
sudo darwin-rebuild switch --flake .#aarch64-darwin
```

- NixOS:

```bash
sudo nixos-rebuild switch --flake .#<platform>  # e.g., x86_64-linux or aarch64-linux
```

1. (Optional) Build only

```bash
nix run .#build                         # macOS build-only
sudo nixos-rebuild build --flake .#<platform>
```

## Layout

- `flake.nix` / `flake.lock`: Flake entrypoint and locked inputs
- `apps/`: Helper run targets per system (e.g., `aarch64-darwin/build`, `build-switch`, `apply`)
  - `build`: build only
  - `build-switch`: build, then switch using the freshly built `darwin-rebuild`
  - `apply`: personalize templates (replace `%USER%`, `%EMAIL%`, `%NAME%`, etc.); it does not build or switch
- `hosts/`
  - `darwin/`: macOS host modules (system defaults, packages) composed via nix-darwin
  - `nixos/`: NixOS host modules (disks, services, desktop, etc.)
- `modules/`
  - `shared/`: Cross-platform Home Manager modules, shared packages, files
  - `darwin/`: macOS-specific modules (e.g., `casks.nix`, Dock, Home Manager glue)
  - `nixos/`: Linux-specific modules (disk layout, X11/WM config, theming)
- `overlays/`: Nix overlays (custom packages/overrides), e.g., fonts

## Common commands

Run from repository root.

### Update inputs

```bash
nix flake update
```

### Build (don’t switch)

- macOS (via flake app):

```bash
nix run .#build
```

- NixOS (direct build):

```bash
sudo nixos-rebuild build --flake .#<platform>   # e.g., x86_64-linux or aarch64-linux
```

### Build and switch

- macOS (via flake apps):

```bash
nix run .#build-switch
```

- macOS (direct):

```bash
darwin-rebuild switch --flake .#<platform>      # aarch64-darwin or x86_64-darwin
```

- NixOS (direct):

```bash
sudo nixos-rebuild switch --flake .#<platform>  # x86_64-linux or aarch64-linux
```

### Platform selection (no per-host keys)

This flake exposes system configurations keyed by platform (not hostname). That mirrors the upstream design; see the
maintainer's explanation here: [Per host configuration — discussions/68](https://github.com/dustinlyons/nixos-config/discussions/68).

- macOS examples:

```bash
darwin-rebuild switch --flake .#aarch64-darwin
# or
nix run .#build-switch        # uses platform-specific app under apps/aarch64-darwin
```

- NixOS examples:

```bash
sudo nixos-rebuild switch --flake .#x86_64-linux
```

### True per-host keys (optional)

If you need explicit host keys (e.g., `work-mbp`, `personal-mbp`), you can define named entries under
`darwinConfigurations`/`nixosConfigurations`. Create a shared `common.nix` plus small host-specific files:

```nix
# flake.nix (fragment)
darwinConfigurations = {
  work-mbp = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ ./hosts/darwin/common.nix ./hosts/darwin/work-mbp.nix ];
  };
  personal-mbp = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ ./hosts/darwin/common.nix ./hosts/darwin/personal-mbp.nix ];
  };
};
```

Usage:

```bash
darwin-rebuild switch --flake .#work-mbp
sudo nixos-rebuild switch --flake .#desktop
```

**Note:** The upstream repo optimizes for platform-keyed configs for simplicity. Prefer a single host per platform
when possible. Only introduce per-host keys if you need truly divergent configurations
([discussion](https://github.com/dustinlyons/nixos-config/discussions/68)).

## Notes

- This repo is intentionally concise. For more advanced features (secrets management, install scripts, macOS
  defaults), see [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config).
- Home Manager handles user programs and shells (fish/zsh), while nix-darwin/NixOS handle system-level
  configuration.
- Shared modules keep duplication low across platforms; host files add machine-specific choices.
