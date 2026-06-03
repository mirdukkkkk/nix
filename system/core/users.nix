{ pkgs, ... }:
{
    users.users = {
        mirdukkkkk = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" "input" "docker" ];
            shell = pkgs.zsh;
        };
    };
}