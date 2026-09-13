{ config, lib, ... }:
let
  cfg = config.my.system.fish;
in
{
  options.my.system.fish.enable = lib.mkEnableOption "fish as the system shell";

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
  };
}
