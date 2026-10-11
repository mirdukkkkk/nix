{
  lib,
  appimageTools,
  fetchurl,
  runCommand,
  patchelf,
}:
let
  pname = "creality-print";
  version = "7.3.0.6157";

  src = fetchurl {
    url = "https://github.com/CrealityOfficial/CrealityPrint/releases/download/v${lib.versions.pad 3 version}/CrealityPrint-V${version}-x86_64-Release.AppImage";
    hash = "sha256-Vd7bQ5KLeS4xHTIjvIByQC2E7UVswFI54CehApfImVU=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  # the binary wants Debian's libbz2.so.1.0; nixpkgs bzip2 only has the soname
  # libbz2.so.1, so the .so.1.0 symlink never makes it into ld.so.cache
  patchedContents = runCommand "${pname}-${version}-patched" { nativeBuildInputs = [ patchelf ]; } ''
    cp -r ${appimageContents} $out
    chmod -R u+w $out
    patchelf --replace-needed libbz2.so.1.0 libbz2.so.1 $out/bin/CrealityPrint
  '';
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = patchedContents;

  # AppRun puts the bundled usr/lib on LD_LIBRARY_PATH and sets LC_ALL=C;
  # these are the remaining system libraries the binary links against
  extraPkgs =
    pkgs: with pkgs; [
      webkitgtk_4_1
      libsoup_3
      glib-networking
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
      libdeflate
      libtiff
      libxkbcommon
      wayland
      dbus
      zstd
      bzip2
    ];

  profile = ''
    export GIO_EXTRA_MODULES=/usr/lib/gio/modules
    export GST_PLUGIN_SYSTEM_PATH_1_0=/usr/lib/gstreamer-1.0
    # otherwise it asks on every start whether to use /etc/pki/tls/certs/ca-bundle.crt
    export SSL_CERT_FILE=''${SSL_CERT_FILE:-/etc/ssl/certs/ca-certificates.crt}
    # same as nixpkgs orca-slicer: webview renders blank without it
    export WEBKIT_DISABLE_COMPOSITING_MODE=''${WEBKIT_DISABLE_COMPOSITING_MODE:-1}
  '';

  extraInstallCommands = ''
    install -Dm444 ${patchedContents}/CrealityPrint.desktop $out/share/applications/creality-print.desktop
    substituteInPlace $out/share/applications/creality-print.desktop \
      --replace-fail 'Exec=AppRun %F' 'Exec=${pname} %F' \
      --replace-fail 'Name=CrealityPrint' 'Name=Creality Print' \
      --replace-fail 'Categories=Utility;' 'Categories=Graphics;3DGraphics;Engineering;'
    install -Dm444 ${patchedContents}/usr/share/icons/hicolor/192x192/apps/CrealityPrint.png \
      $out/share/icons/hicolor/192x192/apps/CrealityPrint.png
  '';

  meta = {
    description = "Slicer for Creality 3D printers, based on OrcaSlicer";
    homepage = "https://www.creality.com/download";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
