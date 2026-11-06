{
  # CCID / Smart Card support
  services.pcscd.enable = true;

  # USB access for Pico FIDO
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1050", ATTR{idProduct}=="0407", TAG+="uaccess"
  '';
}
