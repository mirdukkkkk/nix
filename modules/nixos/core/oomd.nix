{
  # Kill on memory pressure (PSI) before the kernel OOM killer would, which
  # only fires after minutes of thrashing through zram and disk swap. User
  # slices cover the desktop: Plasma puts every app in its own scope, so the
  # whole app goes rather than one random process. system.slice (minecraft,
  # docker) is left alone.
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
  };
}
