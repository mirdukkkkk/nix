{ pkgs, inputs, ... }:
let
  statusLine = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [
      pkgs.jq
      pkgs.git
    ];
    text = builtins.readFile ./statusline.sh;
  };

  formatHook = pkgs.writeShellApplication {
    name = "claude-format-hook";
    runtimeInputs = [
      pkgs.jq
      pkgs.nixfmt
    ];
    text = builtins.readFile ./format-hook.sh;
  };
in
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [ anthropic.claude-code ];
  };

  programs.claude-code = {
    enable = true;

    settings = {
      model = "opus";
      theme = "dark";
      tui = "fullscreen";
      effortLevel = "high";
      includeCoAuthoredBy = false;
      awaySummaryEnabled = false;
      agentPushNotifEnabled = true;

      # Not CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC / DISABLE_TELEMETRY:
      # both turn off GrowthBook feature flags, which Remote Control needs
      env = {
        DISABLE_ERROR_REPORTING = "1";
        DISABLE_BUG_COMMAND = "1";
        DISABLE_FEEDBACK_COMMAND = "1";
      };

      permissions = {
        defaultMode = "auto";
      };

      statusLine = {
        type = "command";
        command = "${statusLine}/bin/claude-statusline";
        padding = 0;
        refreshInterval = 30;
      };

      hooks.PostToolUse = [
        {
          matcher = "Edit|MultiEdit|Write";
          hooks = [
            {
              type = "command";
              command = "${formatHook}/bin/claude-format-hook";
            }
          ];
        }
      ];
    };

    skills = {
      security-audit = "${inputs.security-audit-skill}/skills/security-audit";
      ascii-art = "${inputs.ascii-art}";
    };

    agents.race-hunter = ./agents/race-hunter.md;

    rules = {
      communication = ./rules/communication.md;
      environment = ./rules/environment.md;
      commits = ./rules/commits.md;
    };
  };
}
