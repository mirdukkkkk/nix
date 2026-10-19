# TODO: drop once nixpkgs-unstable ships iloader >= 2.3.10
{ unstable }:
unstable.iloader.overrideAttrs (
  finalAttrs: old: {
    version = "2.3.10";

    src = unstable.fetchFromGitHub {
      owner = "nab138";
      repo = "iloader";
      rev = "v${finalAttrs.version}";
      hash = "sha256-/EdansvwPZN9a49I/NuVROfnGwRtpa/XBnSUGF8b95g=";
    };

    nodeModules = old.nodeModules.overrideAttrs {
      inherit (finalAttrs) src version;
      outputHash = "sha256-v6Hy3fmbpArVJh0YLJZGKH65nXiWPMjUsu1nPKdHlQ8=";
    };

    cargoDeps = unstable.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/src-tauri";
      hash = "sha256-FLhisKy+vu0/ogKn8pPL0NB1vHephQtAMzQ7NWgwoEs=";
    };
  }
)
