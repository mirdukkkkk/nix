{ config, lib, osConfig ? { }, ... }:
let
    cfg = config.my.shell.fish;
in
{
    options.my.shell.fish.enable = lib.mkOption {
        type = lib.types.bool;
        default = osConfig.my.system.fish.enable or false;
        defaultText = lib.literalExpression "osConfig.my.system.fish.enable";
        description = "User-level fish configuration.";
    };

    config = lib.mkIf cfg.enable {
        # Autosuggestions and syntax highlighting are built into fish,
        # no plugins needed for what oh-my-zsh provided on the zsh side.
        programs.fish.enable = true;

        # Only fires in login shells; drop fish's default banner.
        programs.fish.loginShellInit = "set --erase fish_greeting";
    };
}
