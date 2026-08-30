{ config, lib, pkgs, ... }:
let
    cfg = config.my.services.usbmuxd;
in
{
    options.my.services.usbmuxd.enable = lib.mkEnableOption "usbmuxd — connecting iOS devices";

    config = lib.mkIf cfg.enable {
        services.usbmuxd = {
            enable = true;
            package = pkgs.usbmuxd2;
        };

        environment.systemPackages = with pkgs; [
            libimobiledevice
            ifuse
        ];
    };
}
