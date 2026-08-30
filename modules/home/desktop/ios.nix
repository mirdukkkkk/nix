{ config, lib, osConfig ? { }, pkgs, ... }:
let
    cfg = config.my.desktop.ios;
in
{
    options.my.desktop.ios.enable = lib.mkOption {
        type = lib.types.bool;
        default = osConfig.my.services.usbmuxd.enable or false;
        defaultText = lib.literalExpression "osConfig.my.services.usbmuxd.enable";
        description = "Apps for working with iOS devices.";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [ iloader ];
    };
}
