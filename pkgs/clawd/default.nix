{
  lib,
  buildNpmPackage,
  nodejs_22,
  electron,
  makeWrapper,
  src,
}:
buildNpmPackage {
  pname = "clawd-on-desk";
  version = "0.13.0";

  inherit src;

  npmDepsHash = "sha256-bILS4VxGmBCM3g6Cizj7tZcf0wZY6QoPxmo6+ViCy8A=";

  nodejs = nodejs_22;
  dontNpmBuild = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/clawd-on-desk
    cp -r . $out/lib/clawd-on-desk

    # verify-electron-install.js now requires a `version` file next to the
    # electron binary on every platform, and cross-checks its contents
    # against node_modules/electron/package.json's declared version — which
    # can be a different patch than whatever nixpkgs currently ships. We
    # can't write into the nixpkgs electron store path itself, so build our
    # own writable "dist" dir: a symlink to the real binary, plus a version
    # file matching the actual locked npm electron version.
    electronDist="$out/lib/clawd-on-desk-electron-dist"
    mkdir -p "$electronDist"
    ln -s ${electron}/bin/electron "$electronDist/electron"
    node -e "process.stdout.write(require('./node_modules/electron/package.json').version)" > "$electronDist/version"

    mkdir -p $out/bin
    makeWrapper ${nodejs_22}/bin/node $out/bin/clawd-on-desk \
      --add-flags "$out/lib/clawd-on-desk/launch.js" \
      --set ELECTRON_OVERRIDE_DIST_PATH "$electronDist" \
      --set CLAWD_SKIP_SIDECAR_FETCH "1" \
      --set CLAWD_DISABLE_SANDBOX "1"

    mkdir -p $out/share/applications
    cat > $out/share/applications/clawd-on-desk.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Clawd on Desk
Comment=Pixel desktop pet that watches your AI coding agents
Exec=$out/bin/clawd-on-desk
Icon=$out/lib/clawd-on-desk/assets/tray-icon.png
Categories=Utility;
Terminal=false
EOF
    substituteInPlace $out/share/applications/clawd-on-desk.desktop \
      --replace '$out' "$out"

    runHook postInstall
  '';

  meta = {
    description = "Pixel desktop pet that watches Claude Code, Codex, Cursor & other AI coding agents";
    homepage = "https://github.com/rullerzhou-afk/clawd-on-desk";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "clawd-on-desk";
  };
}
