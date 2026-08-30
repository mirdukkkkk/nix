{ pkgs, ... }:
{
    home.packages = with pkgs; [
        bat
        #ripgrep
        #fd
        duf
        dust
        bottom
    ];

    home.shellAliases = {
        cat = "bat";

        top = "btm";

        #grep = "rg";
        #find = "fd";

        df = "duf";
        du = "dust";
    };
}
