{ config, lib, osConfig ? { }, ... }:
let
    cfg = config.my.shell.zsh;
in
{
    options.my.shell.zsh.enable = lib.mkOption {
        type = lib.types.bool;
        default = osConfig.my.system.zsh.enable or false;
        defaultText = lib.literalExpression "osConfig.my.system.zsh.enable";
        description = "User-level zsh configuration.";
    };

    config = lib.mkIf cfg.enable {
        programs.zsh = {
            enable = true;
            syntaxHighlighting.enable = true;
            autosuggestion.enable = true;
            oh-my-zsh = {
                enable = true;
                plugins = [ "git" ];
                theme = "essembeh";
            };
        };
    };
}
