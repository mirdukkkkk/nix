{
  # Every btrfs mount here is a subvolume of the same device, and scrub works
  # per device, so one mount point covers all of them. The default (every
  # btrfs mount) would scrub the same disk five times over.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/persist" ];
  };
}
