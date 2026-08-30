{ pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;

        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                catppuccin.catppuccin-vsc
                catppuccin.catppuccin-vsc-icons
                esbenp.prettier-vscode
                github.github-vscode-theme
                leonardssh.vscord
                ms-vscode.makefile-tools
                oderwat.indent-rainbow
            ];

            userSettings = {
                "telemetry.telemetryLevel" = "off";

                "workbench.iconTheme" = "catppuccin-macchiato";
                "workbench.colorTheme" = "Catppuccin Macchiato";
                "workbench.activityBar.location" = "top";

                "editor.cursorBlinking" = "smooth";

                "editor.smoothScrolling" = true;
                "editor.stickyScroll.enabled" = false;
                "editor.stickyScroll.scrollWithEditor" = false;

                "files.autoSave" = "onFocusChange";
                "files.insertFinalNewline" = true;
                "files.trimTrailingWhitespace" = true;

                "window.titleBarStyle" = "custom";

                "vscord.app.name" = "Visual Studio Code";

                "editor.defaultFormatter" = "esbenp.prettier-vscode";
                "editor.formatOnPaste" = true;
                "editor.formatOnSave" = true;
                "prettier.tabWidth" = 4;

                "[json]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[jsonc]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };

                "[yaml]" = {
                    "editor.tabSize" = 2;
                    "editor.insertSpaces" = true;
                    "editor.detectIndentation" = false;
                };
                "[yml]" = {
                    "editor.tabSize" = 2;
                    "editor.insertSpaces" = true;
                    "editor.detectIndentation" = false;
                };
            };
        };
    };
}
