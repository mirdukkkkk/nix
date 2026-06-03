{
    boot = {
        initrd = {
            availableKernelModules = [ "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
            kernelModules = [ ];
        };

        kernelModules = [
            "kvm-intel"

            "nf_tproxy_ipv4"
            "nf_tproxy_ipv6"
            "nft_tproxy"
            "nft_socket"
        ];
        extraModulePackages = [ ];

        kernelParams = [
            "nowatchdog"
            "mitigations=off"
            "split_lock_detect=off"
            "nvme_core.io_timeout=30"
            "nvme_core.default_ps_max_latency_us=0"
            "init_on_alloc=0"
            "init_on_free=0"
            "pci=realloc"
            "nohz_full=1-11"
        ];

        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        tmp = {
            useTmpfs = true;
            cleanOnBoot = true;
            tmpfsHugeMemoryPages = "advise";
            tmpfsSize = "50%";
        };
    };
}
