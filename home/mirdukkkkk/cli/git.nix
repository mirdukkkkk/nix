{ pkgs, ... }:
{
    programs.git = {
        enable = true;
        settings = {
            user = {
                email = "karmulav@gmail.com";
                name = "mirdukkkkk";
            };
        };
    };

    home.packages = with pkgs; [
        gh
        github-desktop
    ];
}
