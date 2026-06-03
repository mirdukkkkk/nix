{ pkgs, inputs, ... }:
let
    flameflag = import inputs.flameflag {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
    };
in
{
    programs.discord = {
        enable = true;
        package = flameflag.discord.override {
            #withOpenASAR = true;
            withKrisp = true;
            withTTS = false;
        };

        settings = {
            DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
            #SKIP_HOST_UPDATE = true;
            #SKIP_MODULE_UPDATE = true;

            IS_MAXIMIZED = false;
            IS_MINIMIZED = false;

            openH264Enabled = true;

            #openasar = {
            #    setup = true;
            #};

            #WINDOW_BOUNDS = {
            #    x = 1600;
            #    y = 196;
            #    width = 1280;
            #    height = 720;
            #};
        };
    };
}
