{
  config,
  lib,
  pkgs,
  ...
}:
let
  # TODO: drop once nixpkgs bumps nct6687d past the strncpy -> strscpy fix;
  # the pinned 2026-03-13 snapshot fails to build against Linux 7.2.

  # https://github.com/NixOS/nixpkgs/pull/565042
  nct6687d = config.boot.kernelPackages.nct6687d.overrideAttrs {
    version = "0-unstable-2026-10-18";
    src = pkgs.fetchFromGitHub {
      owner = "Fred78290";
      repo = "nct6687d";
      rev = "7e3d7b36c55f06ab5bb2077bc85329f592996b2a";
      hash = "sha256-Z/7lkvtg+1bKkobaAdUAYGQdRgvbWbKNradIv4MTA30=";
    };
  };
in
{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
      systemd.enable = true;

      # btrfs keeps its own UUID inside, so filesystems.nix still mounts it by-uuid
      luks.devices.cryptroot = {
        device = "/dev/disk/by-uuid/551b91fb-3640-4b19-9476-354066c37036";
        crypttabExtraOpts = [ "tpm2-device=auto" ];
        # let discard=async reach the NVMe through dm-crypt
        allowDiscards = true;
        # skip dm-crypt's kernel workqueues: lower latency on NVMe with AES-NI
        bypassWorkqueues = true;
      };
    };

    kernelModules = [
      "kvm-amd"
      "nct6687"
    ];
    extraModulePackages = [ nct6687d ];

    kernelParams = [
      "preempt=full"
      "threadirqs"
      "nowatchdog"
      "amd_pstate=active"
      "random.trust_cpu=0"
    ];

    loader = {
      timeout = 5;
      efi.canTouchEfiVariables = true;
      # replaced by lanzaboote, which signs systemd-boot and UKIs for Secure Boot
      systemd-boot = {
        enable = lib.mkForce false;
        consoleMode = "max";
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 10;
    };

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsHugeMemoryPages = "advise";
      tmpfsSize = "50%";
    };
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
