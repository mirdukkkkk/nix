{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (unstable.bottles.override {
      removeWarningPopup = true;
    })
  ];
}
