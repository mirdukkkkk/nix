{ pkgs, ... }:
let
    resolution = "1920x1080";
    bpp = "32";
    fb = "${resolution}x${bpp}";
in
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
            "threadirqs"
            "nowatchdog"
            "mitigations=off"
            "split_lock_detect=off"
            "nvme_core.io_timeout=30"
            "nvme_core.default_ps_max_latency_us=0"
            "init_on_alloc=0"
            "pci=realloc"
            #"nohz_full=1-11"
        ];

        loader = {
            timeout = 5;
            efi.canTouchEfiVariables = true;
            limine = {
                enable = true;
                maxGenerations = 10;
                extraEntries = ''
                    /memtest86
                        protocol: efi
                        path: boot():/limine/efi/memtest86/memtest86.efi
                '';
                additionalFiles = {
                    "efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
                };

                resolution = fb;
                style = {
                    interface = {
                        resolution = resolution;
                    };
                    wallpapers = [ "/etc/nixos/system/kernel/W4yfarer_-2052483241416810764-01.jpg" ];
                    wallpaperStyle = "stretched";
                };
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
