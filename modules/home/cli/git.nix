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

    # Ставит gh и, главное, сам прописывает credential helper в
    # управляемый ~/.config/git/config. `gh auth setup-git` этого делать
    # нельзя: он вписывает абсолютный путь до бинарника в store, и после
    # первого же обновления gh старый путь собирает GC.
    #
    # hosts.yml (там токен) модуль не трогает, пока пуст programs.gh.hosts.
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
