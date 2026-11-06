{
  security = {
    sudo.enable = false;

    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };

    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        settings.cue = true;
      };
      services = {
        sudo.u2f.enable = true;
        polkit-1.u2f.enable = true;
        kde.u2f.enable = true;
      };
    };
  };
}
