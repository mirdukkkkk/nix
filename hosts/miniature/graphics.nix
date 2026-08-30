{
    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true;
        };

        amdgpu.overdrive = {
            enable = true;
            ppfeaturemask = "0xffffffff";
        };
    };

    #environment.variables = {
    #    ROC_ENABLE_PRE_VEGA = "1";
    #};

    #nixpkgs.config.rocmSupport = true;
}
