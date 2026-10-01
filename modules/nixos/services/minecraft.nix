{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.minecraft;
  dataDir = "/var/lib/minecraft";

  # nixpkgs ships an older Paper and its download URL (api.papermc.io/v2) is gone.
  paper =
    (pkgs.callPackage "${pkgs.path}/pkgs/games/papermc/derivation.nix" {
      jre = pkgs.javaPackages.compiler.temurin-bin.jre-25;
      version = "26.2-128";
      hash = "sha256-he/WeawbXAEzqlPqQiL83GW4pbDX9OhUl7ZHR/GWNKo=";
    }).overrideAttrs
      (old: {
        src = pkgs.fetchurl {
          url = "https://fill-data.papermc.io/v1/objects/85efd679ac1b5c0133aa53ea4222fcdc65b8a5b0d7f4e85497b64747f19634aa/paper-26.2-128.jar";
          inherit (old) hash;
        };
      });

  plugins = {
    GSit = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/GOHbQGyX/versions/gnY5Flgo/GSit-3.7.0.jar";
      hash = "sha256-FD04UJ9JxAshSIetPGgsjbf92BxhB4fQGG1l9RJW9NI=";
    };
    AutoTreeChopper = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/pwCm0TtE/versions/o9SdPqFP/AutoTreeChop-1.7.5.jar";
      hash = "sha256-30BMqlrWad1JLlC1R7ljheajns28u1NHXbVgZdv4uD4=";
    };
    PacketEvents = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/HYKaKraK/versions/m78nFxYg/packetevents-spigot-2.14.0.jar";
      hash = "sha256-BgCHxY7CaOrn3Q6x8XrDvqHqrdoWk0FBQf9k5QYJG9c=";
    };
    AuthMeReloaded = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9js4IEHC/versions/fPuH4uYs/AuthMe-6.0.1-Paper.jar";
      hash = "sha256-dwQzXp5zpjTZ2SY0T3eJf0x094+CRTpZ9aoPjSciRQo=";
    };
    SkinsRestorer = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/TsLS8Py5/versions/ziIzW16f/SkinsRestorer.jar";
      hash = "sha256-qFtKNw+Yh0HJo49NBJgmLtrL8yIDFHkKwcEnRhmWNZw=";
    };
    HuskHomes = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/J6U9o3JG/versions/eXHdkjXf/HuskHomes-Paper-4.11-9ed80cc.jar";
      hash = "sha256-hlkURf/8JFM7w+dt5d8Bzd5QARyA2IpF0Os/4SPWF6s=";
    };
    Chunky = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/fALzjamp/versions/MdY6JATr/Chunky-Bukkit-1.5.3.jar";
      hash = "sha256-Uw0sdDCpajmVc5G3CIvhRNqjEI92ZYltHCOqjdSvMvM=";
    };
    CoreProtect = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Lu3KuzdV/versions/3sehX6Sg/CoreProtect-CE-24.1.jar";
      hash = "sha256-oqzvfAbvIBNVzvB9WRpgVd/tNYrXaPqqqvTidoZezJc=";
    };
    WorldEdit = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/F5ea2ov3/worldedit-bukkit-7.4.5.jar";
      hash = "sha256-5WlqbQZLmWlDeoiIvpGwlBFIoo4MNzbeFVSgAlSl0UI=";
    };
  };

  # Aikar's G1 flags, sized for the 6G heap below.
  jvmOpts = [
    "-Xms6G"
    "-Xmx6G"
    "-XX:+AlwaysPreTouch"
    "-XX:+UseG1GC"
    "-XX:+ParallelRefProcEnabled"
    "-XX:MaxGCPauseMillis=200"
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+DisableExplicitGC"
    "-XX:G1NewSizePercent=30"
    "-XX:G1MaxNewSizePercent=40"
    "-XX:G1HeapRegionSize=8M"
    "-XX:G1ReservePercent=20"
    "-XX:G1HeapWastePercent=5"
    "-XX:G1MixedGCCountTarget=4"
    "-XX:InitiatingHeapOccupancyPercent=15"
    "-XX:G1MixedGCLiveThresholdPercent=90"
    "-XX:G1RSetUpdatingPauseTimePercent=5"
    "-XX:SurvivorRatio=32"
    "-XX:MaxTenuringThreshold=1"
    "-Dusing.aikars.flags=https://mcflags.emc.gs"
    "-Daikars.new.flags=true"
  ];

in
{
  options.my.services.minecraft.enable = lib.mkEnableOption "the Paper Minecraft server";

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      inherit dataDir;
      package = paper;
      jvmOpts = lib.concatStringsSep " " jvmOpts;

      # Everything the server rewrites at runtime -- server.properties,
      # whitelist.json, ops.json and the Paper/Spigot/Bukkit yml files -- stays
      # in the data directory and is owned by the server, so /whitelist and /op
      # work in game. The upstream declarative mode symlinks whitelist.json into
      # the store, which makes those commands fail.
      declarative = false;
    };

    # Players reach the server through xray, so start after it. `wants` rather
    # than `requires`: an xray restart must not take the server down with it.
    # `after multi-user.target` keeps it out of the boot transaction entirely,
    # so a crash-loop here can never delay "system is up".
    systemd.services.minecraft-server = {
      wants = [
        "xray.service"
        "network-online.target"
      ];
      after = [
        "xray.service"
        "network-online.target"
        "multi-user.target"
      ];

      preStart = lib.mkAfter (
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: jar: "install -D -m 0644 ${jar} plugins/${name}.jar") plugins
        )
        + "\n"
      );
    };

    # dataDir lives on its own @minecraft subvolume (see filesystems.nix),
    # so no preservation entry is needed here -- root is tmpfs, but this
    # mount is a real disk subvolume that survives on its own.
  };
}
