{
  config,
  lib,
  osConfig ? { },
  ...
}:
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

    # interactiveShellInit (not loginShellInit) so this fires for every
    # interactive shell, not just TTY logins - kitty/tmux windows are
    # non-login shells and would otherwise still show the banner.
    #
    # Must be set to an empty string, not erased: fish_greeting falls
    # back to its hardcoded default text when the variable is unset.
    programs.fish.interactiveShellInit = "set -g fish_greeting";
  };
}
