{
  services.lact.enable = true;

  # The LACT GUI writes its tuning to /etc/lact/config.yaml, which lives on
  # the tmpfs root. The whole directory is preserved rather than the single
  # file, so an atomic write-and-rename can't break a file bind mount.
  preservation.preserveAt."/persist".directories = [ "/etc/lact" ];
}
