{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        libreoffice-qt
        hunspell
        #(pkgs.libreoffice.override {
        #    unwrapped = pkgs.libreoffice.unwrapped.override {
        #        withJava = false;
        #        kdeIntegration = true;
        #    };
        #})
    ];
}
