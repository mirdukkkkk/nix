{
  boot = {
    initrd = {
      availableKernelModules = [
        "ehci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
      systemd.enable = true;
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    kernelParams = [
      "threadirqs"
      "nowatchdog"
      "mitigations=off"
      "split_lock_detect=off"
      "nvme_core.io_timeout=30"
      "nvme_core.default_ps_max_latency_us=0"
      "init_on_alloc=0"
      "pci=realloc"
      "random.trust_cpu=0"
      #"nohz_full=1-11"
    ];

    loader = {
      timeout = 5;
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

  # `nowatchdog` above only disables the softlockup/NMI lockup detector, not
  # the discrete hardware watchdog timers (iTCO_wdt, intel_oc_wdt) this board
  # exposes as /dev/watchdog*. systemd's own upstream default arms whichever
  # one it finds for 10min as a shutdown-hang safety net, then can't always
  # cleanly disarm iTCO_wdt on close -- hence "watchdog did not stop!" on
  # every shutdown/reboot. Disabling this rearms nothing, so the message
  # never fires. Set on both systemd instances: the initrd one runs the
  # final unmount-real-root stage of shutdown (boot.initrd.systemd.enable
  # above), so it can independently re-arm the same watchdog if left alone.
  systemd.settings.Manager.RebootWatchdogSec = "0";
  boot.initrd.systemd.settings.Manager.RebootWatchdogSec = "0";
}
