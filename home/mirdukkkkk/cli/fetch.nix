{ pkgs, ... }:
{
    home.packages = with pkgs; [ beefetch ];

    programs.fastfetch = {
        enable = true;
        settings = { };
    };

    programs.hyfetch = {
        enable = true;
        settings = {
            preset = "transgender";
            mode = "rgb";
            auto_detect_light_dark = true;
            light_dark = "dark";
            lightness = 0.65;
            color_align = {
                mode = "horizontal";
            };
            backend = "fastfetch";
            args = null;
            distro = "nixos";
            pride_month_disable = false;
            custom_ascii_path = null;
        };
    };
}
