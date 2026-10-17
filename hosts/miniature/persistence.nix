{
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      directories = [
        "/var/lib/systemd/timers"
        # Secure Boot keys used by lanzaboote
        "/var/lib/sbctl"
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/var/lib/systemd/random-seed";
          how = "symlink";
          inInitrd = true;
        }
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
