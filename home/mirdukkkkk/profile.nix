{
    imports = [
        # shell
        ../../modules/home/shell/eza.nix
        ../../modules/home/shell/tmux.nix
        ../../modules/home/shell/utils.nix
        ../../modules/home/shell/zoxide.nix

        # cli
        ../../modules/home/cli/claude.nix
        ../../modules/home/cli/fetch.nix
        ../../modules/home/cli/git.nix
        ../../modules/home/cli/monitoring.nix
        ../../modules/home/cli/nix.nix
        ../../modules/home/cli/tools.nix

        # dev
        ../../modules/home/dev/databases.nix
        ../../modules/home/dev/go.nix
        ../../modules/home/dev/javascript.nix
        ../../modules/home/dev/protobuf.nix
        ../../modules/home/dev/python.nix

        # desktop
        ../../modules/home/desktop/chrome.nix
        ../../modules/home/desktop/discord.nix
        ../../modules/home/desktop/firefox
        ../../modules/home/desktop/flameshot.nix
        ../../modules/home/desktop/graphics.nix
        ../../modules/home/desktop/kitty.nix
        ../../modules/home/desktop/obs.nix
        ../../modules/home/desktop/qbittorrent.nix
        ../../modules/home/desktop/spotify.nix
        ../../modules/home/desktop/telegram.nix
        ../../modules/home/desktop/vscode.nix
    ];

    my.cli.nix.flake = "/home/mirdukkkkk/.dotfiles";
}
