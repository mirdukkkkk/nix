{
    boot = {
        initrd = {
            availableKernelModules = [ "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
            kernelModules = [ ];
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
}
