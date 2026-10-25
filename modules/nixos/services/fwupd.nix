{
  services.fwupd.enable = true;

  # Update history, pending UEFI capsule updates (applied on the next boot)
  # and downloaded LVFS metadata; on the tmpfs root they'd be lost on reboot.
  preservation.preserveAt."/persist".directories = [ "/var/lib/fwupd" ];
}
