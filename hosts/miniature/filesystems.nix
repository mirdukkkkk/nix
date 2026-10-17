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

  fileSystems."/persist" = subvol "@persist" // { neededForBoot = true; };
  fileSystems."/nix" = subvol "@nix";
  fileSystems."/home" = subvol "@home";
  fileSystems."/var/log" = subvol "@log";
  fileSystems."/var/lib/docker" = subvol "@docker";
  fileSystems."/var/lib/minecraft" = subvol "@minecraft";

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
      device = "/dev/disk/by-uuid/6a050789-15f0-4d15-866a-da30c65794a0";
      priority = -1;
      discardPolicy = "pages";
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
    ];
  };
}
