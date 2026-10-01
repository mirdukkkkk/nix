{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;

    # Plasma turns on the Orca screen reader, and both Orca and the generic
    # graphical-desktop module turn on speech-dispatcher, which brings
    # ~700 MiB of mbrola voices. No text-to-speech is used here.
    orca.enable = false;
    speechd.enable = false;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    aurorae
    spectacle
    konsole
    kwin-x11
    elisa
    okular
    khelpcenter
    krdp
    kinfocenter
    kdepim-runtime
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    qtsvg
    filelight
    kolourpaint
    kdenlive
  ];
}
