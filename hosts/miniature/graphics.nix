{
    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true;
        };

        amdgpu = {
            initrd.enable = true;
            overdrive.enable = false;
        };
    };

    #environment.variables = {
    #    ROC_ENABLE_PRE_VEGA = "1";
    #};

    #nixpkgs.config.rocmSupport = true;
}
