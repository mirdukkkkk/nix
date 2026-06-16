{ pkgs, inputs, ... }:
let
    discork-vk = import inputs.discord-vk {
        system = pkgs.system;
        config = pkgs.config;
    };
in
{
    programs.discord = {
        enable = true;
        package = discork-vk.discord;

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
