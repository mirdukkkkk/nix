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

        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.route_localnet" = 1;
        "net.ipv6.conf.all.forwarding" = 1;

        "vm.swappiness" = 50;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 50;
        "vm.page-cluster" = 0;
        "vm.vfs_cache_pressure" = 75;

        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 15;

        "kernel.sysrq" = 1;
    };
}
