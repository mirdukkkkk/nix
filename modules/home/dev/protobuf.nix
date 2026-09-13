{ pkgs, ... }:
{
    home.packages = with pkgs; [ buf ];

    # Syntax highlighting + navigation only; its formatter (clang-format,
    # Google 2-space style) fights this repo's 4-space convention, so no
    # editor.defaultFormatter wired up for [proto3].
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        zxh404.vscode-proto3
    ];
}
