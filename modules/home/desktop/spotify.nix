{ pkgs, ... }:
let
  spotify = pkgs.symlinkJoin {
    name = "spotify";

    paths = [ pkgs.spotify ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/spotify \
          --set LD_PRELOAD \
          ${pkgs.spotify-adblock}/lib/libspotifyadblock.so
    '';
  };
in
{
  home.packages = [ spotify ];

  xdg.configFile."spotify-adblock/config.toml".source =
    "${pkgs.spotify-adblock}/share/spotify-adblock/config.toml";
}
