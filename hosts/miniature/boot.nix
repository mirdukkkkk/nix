{ config, pkgs, ... }:
let
  # TODO: drop once nixpkgs bumps nct6687d past the strncpy -> strscpy fix;
  # the pinned 2026-03-13 snapshot fails to build against Linux 7.2.
  nct6687d = config.boot.kernelPackages.nct6687d.overrideAttrs {
    version = "0-unstable-2026-10-13";
    src = pkgs.fetchFromGitHub {
      owner = "Fred78290";
      repo = "nct6687d";
      rev = "060728e8d04e3ee17b5e003a53e0bcb34c60de92";
      hash = "sha256-qAAIwX+R14cMjY9UUO7bfBJDpqrNpILmJg/IW5tOPZ4=";
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
    };

    kernelModules = [
      "kvm-amd"
      # MSI B550 super I/O: fan speeds and board temperatures
      "nct6687"
    ];
    extraModulePackages = [ nct6687d ];

    kernelParams = [
      "preempt=full"
      "threadirqs"
      "nowatchdog"
      # Zen 3 has CPPC; pin the EPP driver instead of relying on the kernel default
      "amd_pstate=active"
      "random.trust_cpu=0"
      #"nohz_full=1-11"
    ];

    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "max";
      };
    };

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsHugeMemoryPages = "advise";
      tmpfsSize = "50%";
    };
  };
}
