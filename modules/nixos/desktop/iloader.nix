{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.iloader
  ];

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd;
  };
}
