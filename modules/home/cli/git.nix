{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        email = "karmulav@gmail.com";
        name = "mirdukkkkk";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };
  };

  home.packages = with pkgs; [
    github-desktop
  ];

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [ github.vscode-github-actions ];

    userSettings = {
      "git.autofetch" = true;
      "git.confirmSync" = false;
    };
  };
}
