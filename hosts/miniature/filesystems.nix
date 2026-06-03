{
    #boot.supportedFilesystems = [ "bcachefs" ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/aae3be35-04cf-4565-b5b0-394b76a7889d";
        fsType = "btrfs";
        options = [ "subvol=@" "noatime" "ssd" "discard=async" "space_cache=v2" "compress=zstd:3" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/E3E7-1149";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/aae3be35-04cf-4565-b5b0-394b76a7889d";
        fsType = "btrfs";
        options = [ "subvol=@home" "noatime" "ssd" "discard=async" "space_cache=v2" "compress=zstd:3" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/aae3be35-04cf-4565-b5b0-394b76a7889d";
        fsType = "btrfs";
        options = [ "subvol=@nix" "noatime" "ssd" "discard=async" "space_cache=v2" "compress-force=zstd:3" ];
    };

    fileSystems."/var/log" = {
        device = "/dev/disk/by-uuid/aae3be35-04cf-4565-b5b0-394b76a7889d";
        fsType = "btrfs";
        options = [ "subvol=@log" "noatime" "ssd" "discard=async" "space_cache=v2" "nodatacow" ];
    };

    swapDevices = [
        {
            device = "/dev/disk/by-uuid/6a050789-15f0-4d15-866a-da30c65794a0";
            priority = 5;
            discardPolicy = "pages";
        }
    ];

    fileSystems."/srv/nfs" = {
        device = "192.168.1.1:/tmp/mnt/624f53e6-50f9-4a27-bf43-9ef316622601";
        fsType = "nfs";
        options = [ "_netdev" "rw" "hard" "vers=3" "nolock" "ac" "x-systemd.automount" ];
    };
}
