{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./input.nix
    #./panels.nix
    ./powerdevil.nix
    ./rules.nix
  ];

  home.packages = [ pkgs.plasma-panel-colorizer ];

  programs.plasma = {
    enable = true;

    workspace = {
      tooltipDelay = 300;
      enableMiddleClickPaste = false;

      iconTheme = "Papirus";
      cursor = {
        theme = "leafSimple";
        size = 32;
      };
    };

    kscreenlocker = {
      autoLock = false;
      timeout = 0;
    };

    krunner = {
      activateWhenTypingOnDesktop = false;
      historyBehavior = "enableSuggestions";
    };

    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    shortcuts = {
      "services/net.local.QT_QPA_PLATFORM=xcb.desktop"._launch = "Print";
    };

    configFile.plasmarc.OSD = {
      Enabled = false;
      kbdLayoutChangedEnabled = false;
    };
  };
}
