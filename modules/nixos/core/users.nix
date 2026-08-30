{ pkgs, config, lib, ... }:
{
    users = {
        mutableUsers = false;

        users = {
            root.hashedPasswordFile = "/persist/.secrets/root-password";

            mirdukkkkk = {
                isNormalUser = true;
                hashedPasswordFile = "/persist/.secrets/mirdukkkkk-password";
                extraGroups = [
                    "wheel"
                    "input"
                    "games"
                ] ++ lib.optional config.my.services.docker.enable "docker";
                shell = if config.my.system.zsh.enable then pkgs.zsh else pkgs.bashInteractive;
            };
        };
    };
}
