{ pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;

        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                prisma.prisma
                esbenp.prettier-vscode
                wakatime.vscode-wakatime
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

                "wakatime.apiKey" = "waka_c9ba47d9-fbe6-4c4a-af73-616c29943fd3";

                "workbench.iconTheme" = "catppuccin-macchiato";
                "workbench.colorTheme" = "Catppuccin Macchiato";
                "workbench.activityBar.location" = "top";

                "editor.cursorBlinking" = "smooth";
                "editor.defaultFormatter" = "esbenp.prettier-vscode";
                "editor.formatOnPaste" = true;
                "editor.formatOnSave" = true;
                "editor.smoothScrolling" = true;
                "editor.stickyScroll.enabled" = false;
                "editor.stickyScroll.scrollWithEditor" = false;

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
