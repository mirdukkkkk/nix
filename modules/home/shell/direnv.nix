{ pkgs, ... }:
{
  # `use flake` in a project's .envrc loads its devShell into the current
  # shell on cd. nix-direnv caches the evaluation and roots it so GC keeps it.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [ mkhl.direnv ];
}
