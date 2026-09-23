{
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;

    "kernel.sched_autogroup_enabled" = 1;

    "vm.min_free_kbytes" = 262144;

    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    "net.core.netdev_max_backlog" = 8192;

    # zram (prio 150) absorbs almost all swapping before the disk swap
    # (prio -1) is ever touched, so lean on it -- but not too hard: zram
    # compression rides the memory bus, and this board runs RAM single
    # channel (bad motherboard), so bandwidth is already scarce.
    "vm.swappiness" = 100;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 50;
    "vm.page-cluster" = 0;
    "vm.vfs_cache_pressure" = 50;

    # The NVMe is a DRAM-less QLC drive (Crucial P3) with a dynamic SLC
    # cache -- smaller, earlier writeback avoids one big burst blowing
    # through that cache and hitting its post-cache write cliff.
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_ratio" = 10;

    "kernel.sysrq" = 1;
  };
}
