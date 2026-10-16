{ pkgs, ... }:
let
  security-audit-skill = pkgs.fetchFromGitHub {
    owner = "cloudflare";
    repo = "security-audit-skill";
    rev = "c1c8a8c1471069fb0e188eeaff69b8e8db6564a8";
    hash = "sha256-oVVACjotkHvllQGxEP8yWaEt4c3GxT0d909TUM5P3NM=";
  };

  ascii-art-skill = pkgs.fetchFromGitHub {
    owner = "mirdukkkkk";
    repo = "ascii-art";
    rev = "403a76f0f67660902eae6552bd8afbabe32d34ad";
    hash = "sha256-Nb5nmdN4mjTMRhWhFFHUtR3unE4rSmixkvZnu9qDDeI=";
  };

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
      security-audit = "${security-audit-skill}/skills/security-audit";
      ascii-art = "${ascii-art-skill}";
    };

    agents.race-hunter = ./agents/race-hunter.md;

    rules = {
      communication = ./rules/communication.md;
      environment = ./rules/environment.md;
      commits = ./rules/commits.md;
    };
  };
}
