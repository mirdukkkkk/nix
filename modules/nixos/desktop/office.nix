{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US
    #(pkgs.libreoffice.override {
    #    unwrapped = pkgs.libreoffice.unwrapped.override {
    #        withJava = false;
    #        kdeIntegration = true;
    #    };
    #})
  ];
}
