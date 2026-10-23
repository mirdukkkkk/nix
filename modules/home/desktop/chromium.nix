{ config, pkgs, ... }:
let
  claudeExtension = "fcoeoabgfenejglbffodgkkbkcdhcgfn";

  # Claude in Chrome talks to Claude Code through this host. Claude Code can
  # write one itself, but outside home-manager; declared here it runs the
  # same package programs.claude-code installs.
  claudeHost =
    let
      host = pkgs.writeShellScript "claude-chrome-native-host" ''
        exec ${config.programs.claude-code.package}/bin/claude --chrome-native-host
      '';
    in
    pkgs.writeTextDir
      "etc/chromium/native-messaging-hosts/com.anthropic.claude_code_browser_extension.json"
      (
        builtins.toJSON {
          name = "com.anthropic.claude_code_browser_extension";
          description = "Claude Code Browser Extension Native Host";
          path = "${host}";
          type = "stdio";
          allowed_origins = [ "chrome-extension://${claudeExtension}/" ];
        }
      );
in
{
  programs.chromium = {
    enable = true;

    # Chromium keeps only the last --enable-features flag, so the Wayland one
    # the nixpkgs wrapper passes has to be repeated here.
    commandLineArgs = [
      "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,WaylandWindowDecorations"
    ];

    # home-manager's plasmaSupport only covers google-chrome,
    # so the plasma integration host is added by hand.
    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
      claudeHost
    ];

    extensions = [
      { id = claudeExtension; } # claude
      { id = "ilcajpmogmhpliinlbcdebhbcanbghmd"; } # preact developer tools
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # google translate
      { id = "epcnnfbjfcgphgdmggkamkmgojdagdnn"; } # ublock
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # plasma integration
    ];
  };
}
