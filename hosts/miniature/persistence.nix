{
    preservation = {
        enable = true;
        preserveAt."/persist" = {
            directories = [
                "/etc/nixos"
                "/var/lib/nixos"
                "/var/lib/AccountsService"
            ];
            files = [
                { file = "/etc/machine-id"; inInitrd = true; how = "symlink"; configureParent = true; }
                { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; }

                { file = "/etc/ssh/ssh_host_ed25519_key"; mode = "0600"; }
                "/etc/ssh/ssh_host_ed25519_key.pub"
                { file = "/etc/ssh/ssh_host_rsa_key"; mode = "0600"; }
                "/etc/ssh/ssh_host_rsa_key.pub"
            ];
        };
    };

    systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

    systemd.services.systemd-machine-id-commit = {
        unitConfig.ConditionPathIsMountPoint = [
            ""
            "/persist/etc/machine-id"
        ];
        serviceConfig.ExecStart = [
            ""
            "systemd-machine-id-setup --commit --root /persist"
        ];
    };
}
