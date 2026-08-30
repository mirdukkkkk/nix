{ pkgs, ... }:
{
    home.packages = with pkgs; [
        claude-code
        #clawd-on-desk
    ];

    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [ anthropic.claude-code ];
    };
}
