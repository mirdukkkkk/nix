{ config, ... }:
let
  # Top level of the btrfs filesystem (subvolid=5): snapshots have to live on
  # the same filesystem as their subvolumes, next to @persist and friends.
  pool = "/mnt/btrfs";
in
{
  fileSystems.${pool} = {
    inherit (config.fileSystems."/persist") device fsType;
    options = [
      "subvolid=5"
      "noatime"
      "x-systemd.automount"
    ];
  };

  # @persist holds password hashes and host keys, so its snapshots must not
  # be readable through a world-traversable directory.
  systemd.tmpfiles.rules = [
    "v ${pool}/@snapshots 0700 root root -"
  ];

  services.btrbk = {
    # snapshots are cheap, but deleting old ones churns metadata; keep that
    # out of the way of games and builds
    ioSchedulingClass = "idle";

    instances.btrbk = {
      onCalendar = "hourly";
      settings = {
        # the default (day only) would make hourly snapshots collide
        timestamp_format = "long";
        # every snapshot for 2 days, then one per day for 2 weeks
        snapshot_preserve_min = "2d";
        snapshot_preserve = "14d";

        volume.${pool} = {
          snapshot_dir = "@snapshots";
          subvolume = {
            "@persist" = { };
            "@minecraft" = { };
          };
        };
      };
    };
  };
}
