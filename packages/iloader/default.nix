# TODO: drop once nixpkgs-unstable ships iloader >= 2.3.8
{ unstable }:
unstable.iloader.overrideAttrs (
  finalAttrs: old: {
    version = "2.3.8";

    src = unstable.fetchFromGitHub {
      owner = "nab138";
      repo = "iloader";
      rev = "v${finalAttrs.version}";
      hash = "sha256-97CTooLPAhYt9tzPGWyJNyJcUqvomR1eaSpWnKleMh4=";
    };

    nodeModules = old.nodeModules.overrideAttrs {
      inherit (finalAttrs) src version;
      outputHash = "sha256-v6Hy3fmbpArVJh0YLJZGKH65nXiWPMjUsu1nPKdHlQ8=";
    };

    cargoDeps = unstable.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/src-tauri";
      hash = "sha256-EwgiDDYDD8jDXO0cKQeJOFNGKWgXZw7txCQ3uFReXKI=";
    };
  }
)
