# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS flake configuration for a single machine: `nixosConfigurations.miniature` (x86_64-linux), NixOS 26.05 with home-manager `release-26.05` for the single user `mirdukkkkk`. There is no application code, no test suite, and no CI — the "build" is a system rebuild.

## Rebuilding

- `nrs` → `sudo nixos-rebuild switch --flake /etc/nixos -L`
- `nrb` → `sudo nixos-rebuild boot --flake /etc/nixos -L`
- `nopt` → `sudo nix store optimise`, `nclean` → `sudo nix-collect-garbage -d` (automatic gc/optimise are disabled in `modules/nixos/core/nix.nix`)

These aliases are defined in `modules/home/cli/nix.nix`; the flake path they point at is the `my.cli.nix.flake` option.

**`/etc/nixos` is a root-owned copy of this tree, not a symlink to it.** The aliases rebuild from `/etc/nixos`, so edits here do not take effect until they are copied over (e.g. `sudo rsync -a --delete ~/dada/ /etc/nixos/`). To rebuild straight from this checkout instead: `sudo nixos-rebuild switch --flake /home/mirdukkkkk/dada#miniature -L`.

Validate changes without applying them (no root needed):

```
nix eval .#nixosConfigurations.miniature.config.system.build.toplevel.drvPath   # быстрая проверка eval
nixos-rebuild build --flake .#miniature -L                                      # full build, then inspect ./result
nix build .#nixosConfigurations.miniature.config.system.path                    # только пакеты, ловит коллизии
```

Updating inputs: `nix flake update` for everything, `nix flake update <input>` for one.

## Architecture: options, not scattered config

The config is a **module library plus two profiles**. Nothing in `modules/` is enabled by itself — every feature declares an option under the `my.*` namespace and wraps its config in `lib.mkIf`:

```nix
{ config, lib, pkgs, ... }:
let cfg = config.my.dev.go;
in {
    options.my.dev.go.enable = lib.mkEnableOption "Go";

    config = lib.mkIf cfg.enable { ... };
}
```

- `modules/nixos/` — NixOS-side features (`core/`, `kernel/`, `desktop/`, `services/`, `gaming.nix`, `packages.nix`).
- `modules/home/` — home-manager features (`cli/`, `dev/`, `desktop/`, `shell/`, `gaming.nix`).
- `hosts/miniature/profile.nix` — **the only place that decides what this machine runs.** Hardware, filesystems, network, bootloader and persistence live beside it in `hosts/miniature/`.
- `home/mirdukkkkk/profile.nix` — the same, for the user.

`modules/nixos/core/{locale,nix,nixpkgs,security,users}.nix` and `packages.nix` are deliberately flagless: they are the foundation every machine needs, not features.

### A feature owns everything it implies

This is the point of the layout — don't scatter a feature's pieces back across the tree:

- `modules/home/dev/go.nix` installs `go`/`gopls` **and** adds the `golang.go` extension and the `[go]` formatter settings to VSCode.
- `modules/nixos/desktop/sound.nix` enables PipeWire **and** `security.rtkit`, which only exists for it.
- `modules/nixos/gaming.nix` owns the `ntsync` kernel module, which only Wine/Proton needs.
- `modules/nixos/services/xray/` owns its nftables ruleset, its `boot.kernelModules`, and the `ip_forward`/`route_localnet` sysctls — nothing tproxy-related lives in the generic tuning module.
- `modules/nixos/services/ssh.nix` opens port 22 itself.

VSCode works as an aggregator: `modules/home/desktop/vscode.nix` holds only the base (theme, editor behaviour, prettier), and every other module appends to `programs.vscode.profiles.default` guarded by `lib.mkIf config.my.desktop.vscode.enable`. The module system merges the extension lists and settings attrsets. To add a language: create one module that adds its packages, its extension, and its `"[lang]"` settings together.

### Cross-layer defaults

Home modules read `osConfig` so a system flag pulls its user-side half automatically. `my.dev.docker`, `my.desktop.ios`, `my.gaming` and `my.shell.zsh` default to their NixOS counterparts (`my.services.docker`, `my.services.usbmuxd`, `my.gaming`, `my.system.zsh`) and are intentionally absent from the user profile. Setting them explicitly there overrides the link.

Group aggregates (`my.desktop.enable`, `my.dev.enable`, `my.shell.enable`) turn on their members with `lib.mkDefault`, so individual members can still be switched off next to the aggregate.

## Overlays and package sources

`modules/nixos/core/nixpkgs.nix` is the single place package sets are assembled, and because home-manager uses `useGlobalPkgs`, these apply in home modules too:

- `pkgs.unstable.*` — a full `nixos-unstable` instance (used for `firefox`, `discord`, `proton-ge-bin`).
- `pkgs.molten` / `pkgs.iloader` / `pkgs.beefetch` — packages pulled from their own flake inputs.
- `pkgs.clawd-on-desk` — `pkgs/clawd/default.nix` called against `unstable`, with the source coming from the `clawd-on-desk` input (`flake = false`, pinned by tag).
- `claude-code` comes from its own input overlay.

`allowUnfree = true`; insecure packages must be listed explicitly in `permittedInsecurePackages`.

## Impermanence — read before adding state

`/` is a **tmpfs wiped on every boot** (`hosts/miniature/filesystems.nix`). Only these survive: the btrfs subvolume mounts (`/persist`, `/nix`, `/home`, `/var/log`, `/var/lib/docker`, `/boot`) and paths listed in `environment.persistence."/persist"` in `hosts/miniature/persistence.nix`.

Any service that needs state under `/var/lib` or `/etc` must have that path added to `persistence.nix`, or it silently resets each boot.

Secrets are plaintext files under `/persist/.secrets` referenced by path (e.g. `hashedPasswordFile` in `modules/nixos/core/users.nix`) and are deliberately outside this repo. `users.mutableUsers = false`, so user changes only happen through this config.

## Transparent proxying (`modules/nixos/services/xray/`)

With `my.services.xray.enable`, all TCP/UDP traffic is transparently routed through a local xray instance:

- `default.nix` builds `services.xray.settings` by `builtins.fromJSON`-ing the five files in `config/` — edit those JSON files, not inline Nix. It also overrides the xray package's `assets` with fetched geoip/geosite `.dat` files.
- `tproxy.nix` supplies the other half: the nftables ruleset, the fwmark policy-routing oneshot, kernel modules and sysctls.
- `my.services.xray.tproxyPort` defaults to the port of the inbound tagged `tproxy` in `config/inbounds.json`, so the ruleset and the xray config cannot drift apart. Don't hardcode the port in either place.

A mistake here breaks all networking on the host, including the ability to fetch anything to fix it — prefer `nixos-rebuild boot` or a test build over `switch` when touching this.

## Conventions

- **4-space indentation** throughout. `nixfmt` is installed (`modules/home/cli/nix.nix`) but the tree is not formatted with it — do not reformat existing files; match surrounding style.
- Every directory has a `default.nix` listing its `imports` explicitly (alphabetized, subdirectories first). A new `.nix` file is dead until it is added there. Directories with a group aggregate (`desktop/`, `dev/`, `shell/`) also declare that option in their `default.nix`.
- **No explanatory comments.** The owner reads Nix fluently and asked for them out. Option `description` fields are fine — they are the option's API, not commentary.
- Commented-out blocks (alternate kernels, bcachefs, ROCm, libreoffice overrides) are intentionally retained as history. Leave them alone unless asked.
- Package versions are pinned by hash where overridden (bun in `modules/home/dev/javascript.nix`, Betterfox and spotify-adblock, clawd's `npmDepsHash`) — changing a version means updating the hash too.
- `modules/home/desktop/firefox/extensions.nix` is **generated**, not hand-written: it comes from `mozilla-addons-to-nix` (installed by that same module) for addons not in the NUR rycee set. Addons that exist in `nur.repos.rycee.firefox-addons` are listed directly in `default.nix`.
