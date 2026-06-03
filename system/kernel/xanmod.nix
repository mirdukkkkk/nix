{ pkgs, config, ... }:
{
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    boot.kernelModules = [ "ntsync" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ bcachefs ];
    /*boot.kernelPackages = pkgs.linuxPackagesFor(pkgs.linuxKernel.kernels.linux_xanmod_latest.override {
        argsOverride = rec {
            src = pkgs.fetchurl {
                url = "https://gitlab.com/xanmod/linux/-/archive/7.0.7-xanmod1.tar.bz2";
                sha256 = "sha256-s29JH2pZTS2QkEVx6UfiCCfaIQX5J0Mw8NcpAXxgZHs=";
            };
            extraMakeFlags = [ "LLVM=1" "LLVM_IAS=1" ];
            stdenv = pkgs.llvmPackages.stdenv;
            version = "7.0.6";
            modDirVersion = "7.0.6-xanmod1";
            ignoreConfigErrors = true;
            structuredExtraConfig = with lib.kernel; {
                # --- LATENCY / RESPONSIVENESS ---
                #PREEMPT_LAZY = yes;
                #NO_HZ_FULL = yes;
                #HZ = freeform "1000";
                #HZ_1000 = yes;

                # --- CPU TIME MODEL ---
                VIRT_CPU_ACCOUNTING = yes;
                VIRT_CPU_ACCOUNTING_GEN = yes;
                TICK_CPU_ACCOUNTING = no;

                # --- SAFE DEBLOAT ---
                CAN = no;
                NFC = no;
                HAMRADIO = lib.mkForce no;
                ATM = no;
                BATMAN_ADV = no;
                CEPH_FS = no;
                NET_9P = no;
                IPACK_BUS = no;
                GPIB = no;
                MEMSTICK = no;
                USB4 = no;
                FPGA = no;

                # --- IO ---
                MQ_IOSCHED_KYBER = yes;

                # --- MODULES ---
                LZ4_COMPRESS = yes;
                MODULE_DECOMPRESS = yes;

                NTSYNC = yes;
                FUTEX = yes;
                FUTEX_PI = yes;
                #TRANSPARENT_HUGEPAGE_MADVISE = yes;
            };
        };
    });*/
}
