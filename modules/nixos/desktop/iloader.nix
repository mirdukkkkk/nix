{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    iloader
  ];

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  preservation.preserveAt."/persist".directories = [
    {
      directory = "/var/lib/lockdown";
      user = "usbmux";
      group = "usbmux";
      mode = "0700";
    }
  ];
}
