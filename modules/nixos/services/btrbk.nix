{ lib, pkgs, ... }:
let
  # @snapshots, mounted in filesystems.nix. Snapshots have to live on the same
  # btrfs filesystem as their sources, which a sibling subvolume satisfies.
  snapshots = "/.snapshots";
in
{
  # A missing or broken @snapshots must not drop the boot into emergency
  # mode; btrbk just fails until it is fixed.
  fileSystems.${snapshots}.options = [ "nofail" ];

  # @persist holds password hashes and host keys, so its snapshots must not
  # be readable through a world-traversable directory.
  systemd.tmpfiles.rules = [
    "z ${snapshots} 0700 root root -"
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

        # Mount points instead of a volume section, so the btrfs top level
        # never has to be mounted. Snapshots are named after the last path
        # component: persist.<timestamp>, minecraft.<timestamp>.
        snapshot_dir = snapshots;
        subvolume = {
          "/persist" = { };
          "/var/lib/minecraft" = { };
        };
      };
    };
  };

  # The module runs btrbk as its own user that escalates through sudo, but
  # sudo-rs.execWheelOnly makes the sudo wrapper executable for wheel only.
  # Local snapshots need root for every btrfs call anyway.
  systemd.services.btrbk-btrbk = {
    unitConfig.RequiresMountsFor = [ snapshots ];
    serviceConfig = {
      User = lib.mkForce "root";
      Group = lib.mkForce "root";
    };
  };
}
