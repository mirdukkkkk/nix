{
  # The NVMe is a QLC drive, which wears out faster than TLC; smartd warns
  # about wear, spare blocks and media errors before data goes missing.
  # Attribute history isn't recorded (no -A), so there is no state to preserve.
  services.smartd = {
    enable = true;
    # wall messages never reach a Wayland session; this shows them as
    # desktop notifications instead.
    notifications = {
      wall.enable = false;
      systembus-notify.enable = true;
    };
  };
}
