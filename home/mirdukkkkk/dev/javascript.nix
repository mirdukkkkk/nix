{ pkgs, ... }:
{
    home.packages = with pkgs; [ 
        bun
        nodejs_24 
        yarn 
    ];
}
