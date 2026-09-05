{ pkgs, ... }:
{
    home.packages = with pkgs; [
        claude-code
    ];

    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [ anthropic.claude-code ];
    };
}
