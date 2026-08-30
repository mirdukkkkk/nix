{
    environment.persistence."/persist" = {
        directories = [
            "/etc/nixos"
            "/var/lib/nixos"
            "/var/lib/AccountsService"
        ];
        files = [
            "/etc/machine-id"
            { file = "/var/lib/systemd/random-seed"; method = "symlink"; }

            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
        ];
    };
}
