# TODO: drop once nixpkgs-unstable ships iloader >= 2.3.10
{ unstable }:
unstable.iloader.overrideAttrs (
  finalAttrs: old: {
    version = "2.4.0";

    src = unstable.fetchFromGitHub {
      owner = "nab138";
      repo = "iloader";
      rev = "v${finalAttrs.version}";
      hash = "sha256-fiMLl0OkG9/+T/gEIAeK23TrPOQzm5e0yk6oX9VFsr8=";
    };

    nodeModules = old.nodeModules.overrideAttrs {
      inherit (finalAttrs) src version;
      outputHash = "sha256-v6Hy3fmbpArVJh0YLJZGKH65nXiWPMjUsu1nPKdHlQ8=";
    };

    cargoDeps = unstable.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/src-tauri";
      hash = "sha256-hn+TQtDLs8/JA/XH4w8rPjC7vujJ1OzX5k80koeZ2s8=";
    };
  }
)
