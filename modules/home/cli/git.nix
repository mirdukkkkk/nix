{ pkgs, ... }:
{
    programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
            user = {
                email = "karmulav@gmail.com";
                name = "mirdukkkkk";
            };
        };
    };

    programs.gh = {
        enable = true;
        settings = {
            git_protocol = "https";
            aliases.co = "pr checkout";
        };
    };

    home.packages = with pkgs; [
        github-desktop
    ];

    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [ github.vscode-github-actions ];

        userSettings = {
            "git.autofetch" = true;
            "git.confirmSync" = false;
        };
    };
}
