{
  systemd.coredump = {
    enable = true;
    settings.Coredump = {
      Storage = "none";
    };
  };
}
