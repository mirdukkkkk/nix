{
  services.journald = {
    storage = "persistent";

    # /var/log lives on its own real (@log) btrfs subvolume, not tmpfs, so
    # this survives reboots without a preservation entry.
    extraConfig = ''
      SystemMaxUse=1G
      SystemKeepFree=5G
      SystemMaxFileSize=128M
      MaxRetentionSec=3month
      # @log subvolume already does zstd, journald's own compression on top
      # of that would just burn CPU for no size win.
      Compress=no
    '';
  };
}
