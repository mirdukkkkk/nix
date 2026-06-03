final: prev:
{
    libreoffice = prev.libreoffice.override {
        unwrapped = prev.libreoffice.unwrapped.override {
            withJava = false;
            kdeIntegration = true;
        };
    };
}
