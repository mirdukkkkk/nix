{ pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;

        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                prisma.prisma
                esbenp.prettier-vscode
                svelte.svelte-vscode
                catppuccin.catppuccin-vsc
                catppuccin.catppuccin-vsc-icons
                github.github-vscode-theme
                oderwat.indent-rainbow
                leonardssh.vscord
                golang.go
                ms-azuretools.vscode-containers
                ms-azuretools.vscode-docker
                bbenoist.nix
            ];

            userSettings = {
                "telemetry.telemetryLevel" = "off";

                "workbench.iconTheme" = "catppuccin-macchiato";
                "workbench.colorTheme" = "Catppuccin Macchiato";
                "workbench.activityBar.location" = "top";

                "git.autofetch" = true;
                "git.confirmSync" = false;

                "editor.cursorBlinking" = "smooth";
                "editor.defaultFormatter" = "esbenp.prettier-vscode";
                "editor.formatOnPaste" = true;
                "editor.formatOnSave" = true;
                "editor.smoothScrolling" = true;
                "editor.stickyScroll.enabled" = false;
                "editor.stickyScroll.scrollWithEditor" = false;

                "files.autoSave" = "onFocusChange";
                "files.insertFinalNewline" = true;
                "files.trimTrailingWhitespace" = true;

                "window.titleBarStyle" = "custom";

                "vscord.app.name" = "Visual Studio Code";

                "prettier.tabWidth" = 4;

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
