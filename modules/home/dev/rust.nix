{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
    rust-analyzer
  ];

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];

    userSettings = {
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "editor.formatOnSave" = true;
      };

      "rust-analyzer.check.command" = "clippy";
    };
  };
}
