{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    ripgrep
    fd
    duf
    dust
  ];

  home.shellAliases = {
    cat = "bat";

    top = "btop";

    #grep = "rg";
    #find = "fd";

    df = "duf";
    du = "dust";
  };
}
