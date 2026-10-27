{
  config,
  lib,
  pkgs,
  ...
}:
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
    extraPackages = [ pkgs.btrfs-progs ];

    instances.btrbk = {
      onCalendar = "hourly";
      settings = {
        # call btrfs directly instead of through sudo, see the service below
        backend = "btrfs-progs";
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

  # The module runs btrbk as its own user that escalates through sudo, but
  # sudo-rs.execWheelOnly makes the sudo wrapper executable for wheel only.
  # Local snapshots need root for every btrfs call anyway.
  #
  # The tmpfiles rule alone isn't enough: on a switch, tmpfiles can run before
  # the new automount for the pool exists, so the service applies it itself.
  systemd.services.btrbk-btrbk = {
    unitConfig.RequiresMountsFor = [ pool ];
    serviceConfig = {
      User = lib.mkForce "root";
      Group = lib.mkForce "root";
      ExecStartPre = "${config.systemd.package}/bin/systemd-tmpfiles --create --prefix=${pool}/@snapshots";
    };
  };
}
