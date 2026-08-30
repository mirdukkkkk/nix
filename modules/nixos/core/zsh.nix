{ config, lib, ... }:
let
    cfg = config.my.system.zsh;
in
{
    options.my.system.zsh.enable = lib.mkEnableOption "zsh as the system shell";

    config = lib.mkIf cfg.enable {
        programs.zsh.enable = true;
    };
}
