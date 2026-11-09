{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Fixes the build with system aws-lc. Drop once
    # https://github.com/NixOS/nixpkgs/pull/585227 reaches nixpkgs-unstable.
    (iloader.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ aws-lc ];
    }))
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
