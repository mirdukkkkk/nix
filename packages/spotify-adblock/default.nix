{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "403b3491cc89d0207c2aa5c349991ba420d97cd1";
    sha256 = "sha256-R1xM/a+EzFd3I94EVCphbW+M114x6CtIeCOi9Fd9tpc=";
  };

  cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/share/spotify-adblock

    cp target/x86_64-unknown-linux-gnu/release/libspotifyadblock.so \
      $out/lib/libspotifyadblock.so
    cp config.toml $out/share/spotify-adblock/config.toml
  '';

  meta = {
    description = "Ad blocker for the Spotify desktop client";
    homepage = "https://github.com/abba23/spotify-adblock";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
