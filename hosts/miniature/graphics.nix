{ pkgs, lib, ... }:
let
  makeMesa = packageSet:
    (packageSet.mesa.override {
      galliumDrivers = [
        "radeonsi"
        "llvmpipe"
      ];

      vulkanDrivers = [
        "amd"
      ];
    }).overrideAttrs (old: {
      outputs = builtins.filter
        (output: output != "spirv2dxil")
        old.outputs;

      postInstall = lib.replaceStrings
        [
          "moveToOutput bin/spirv2dxil $spirv2dxil\n"
          "moveToOutput \"lib/libspirv_to_dxil*\" $spirv2dxil\n"
        ]
        [
          ""
          ""
        ]
        old.postInstall;

      env = (old.env or {}) // {
        NIX_CFLAGS_COMPILE = "-march=znver3";
        NIX_CXXFLAGS_COMPILE = "-march=znver3";
        NIX_LDFLAGS = "";
      };
    });
in
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      package = makeMesa pkgs;
      package32 = makeMesa pkgs.pkgsi686Linux;
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
