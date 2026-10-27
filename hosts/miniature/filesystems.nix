let
  # btrfs applies its own mount options (compress, nodatacow, discard, ...)
  # filesystem-wide, taken from whichever subvolume is mounted first; per-mount
  # values on the other subvolumes are silently ignored. So every subvolume
  # gets the same set, and the only per-mount difference is the subvol itself
  # (noatime is a VFS option and genuinely works per mount).
  disk = "/dev/disk/by-uuid/aae3be35-04cf-4565-b5b0-394b76a7889d";
  options = [
    "noatime"
    "discard=async"
    "compress=zstd:3"
  ];
  subvol = name: {
    device = disk;
    fsType = "btrfs";
    options = [ "subvol=${name}" ] ++ options;
  };
in
{
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "size=4G"
      "mode=755"
    ];
  };

  fileSystems."/persist" = subvol "@persist" // {
    neededForBoot = true;
  };
  fileSystems."/nix" = subvol "@nix";
  fileSystems."/home" = subvol "@home";
  fileSystems."/var/log" = subvol "@log";
  fileSystems."/var/lib/docker" = subvol "@docker";
  fileSystems."/var/lib/minecraft" = subvol "@minecraft";
  # btrbk snapshots (see modules/nixos/services/btrbk.nix); the subvolume has
  # to exist before it can be mounted, so on a fresh disk create it once with
  # `btrfs subvolume create` on the top level
  fileSystems."/.snapshots" = subvol "@snapshots";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E3E7-1149";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # nodatacow can't be set per subvolume via mount options (see above), so
  # use the file attribute instead. +C only applies to files created after
  # it is set on the directory; existing files keep CoW until rewritten.
  systemd.tmpfiles.rules = [
    "h /var/lib/docker    - - - - +C"
  ];

  swapDevices = [
    {
      # by-partuuid, not by-uuid: randomEncryption re-creates the swap with a
      # fresh key every boot, so the filesystem UUID doesn't survive.
      device = "/dev/disk/by-partuuid/28df634f-ae77-4623-a528-9dcda6f9f576";
      priority = -1;
      discardPolicy = "pages";
      randomEncryption = {
        enable = true;
        # let discardPolicy reach the NVMe through dm-crypt
        allowDiscards = true;
      };
    }
  ];

  fileSystems."/srv/nfs" = {
    device = "192.168.1.144:/srv/nfs";
    fsType = "nfs";
    options = [
      "_netdev"
      "rw"
      "hard"
      "vers=3"
      "nolock"
      "ac"
      "x-systemd.automount"
      "x-systemd.mount-timeout=10"
    ];
  };
}
