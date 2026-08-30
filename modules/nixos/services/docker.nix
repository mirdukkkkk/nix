{ config, lib, ... }:
let
    cfg = config.my.services.docker;
in
{
    options.my.services.docker = {
        enable = lib.mkEnableOption "Docker";

        autoStart = lib.mkEnableOption "start the Docker daemon at boot";
    };

    config = lib.mkIf cfg.enable {
        virtualisation.docker.enable = true;

        systemd.services.docker.wantedBy = lib.mkIf (!cfg.autoStart) (lib.mkForce [ ]);
    };
}
