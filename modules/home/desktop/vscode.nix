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
        # Telemetry
        "telemetry.telemetryLevel" = "off";

        # Theme / workbench
        "workbench.iconTheme" = "catppuccin-macchiato";
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.activityBar.location" = "top";
        "window.titleBarStyle" = "custom";

        # Catppuccin's customUIColors/colorOverrides schema is on
        # raw.githubusercontent.com; VS Code's default trust for that host
        # doesn't cover it (github.com/catppuccin/vscode#641), so trust the
        # exact prefix explicitly to silence the "untrusted" warning.
        "json.schemaDownload.trustedDomains" = {
          "https://raw.githubusercontent.com/catppuccin/vscode/" = true;
        };

        # Editor behavior
        "editor.minimap.enabled" = false;
        "editor.cursorBlinking" = "smooth";
        "editor.smoothScrolling" = true;
        "editor.stickyScroll.enabled" = false;
        "editor.stickyScroll.scrollWithEditor" = false;

        # Files
        "files.autoSave" = "onFocusChange";
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;

        # Formatting (default: Prettier)
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

        # Copilot
        "github.copilot.enable" = {
          "*" = true;
          "markdown" = true;
        };

        # vscord (Discord rich presence)
        "vscord.app.name" = "Visual Studio Code";
      };
    };
  };
}
