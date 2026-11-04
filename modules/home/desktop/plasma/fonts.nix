{ pkgs, ... }:
{
  home.packages = with pkgs; [
    comic-relief
    jetbrains-mono
  ];

  programs.plasma.fonts = {
    general = {
      family = "Comic Relief";
      pointSize = 10;
    };
    menu = {
      family = "Comic Relief";
      pointSize = 10;
    };
    toolbar = {
      family = "Comic Relief";
      pointSize = 10;
    };
    small = {
      family = "Comic Relief";
      pointSize = 8;
    };
    windowTitle = {
      family = "Comic Relief";
      pointSize = 10;
    };
    fixedWidth = {
      family = "JetBrains Mono";
      pointSize = 10;
    };
  };
}
