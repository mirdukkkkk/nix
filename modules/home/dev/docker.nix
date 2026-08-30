{ config, lib, osConfig ? { }, pkgs, ... }:
let
    cfg = config.my.dev.docker;
in
{
    options.my.dev.docker.enable = lib.mkOption {
        type = lib.types.bool;
        default = osConfig.my.services.docker.enable or false;
        defaultText = lib.literalExpression "osConfig.my.services.docker.enable";
        description = "Tools for working with Docker.";
    };

    config = lib.mkIf cfg.enable {
        programs.vscode.profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                ms-azuretools.vscode-containers
                ms-azuretools.vscode-docker
            ];
        };
    };
}
