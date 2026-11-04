{
  programs.plasma.input = {
    keyboard = {
      layouts = [
        { layout = "us"; }
        { layout = "ru"; }
      ];
      options = [ "grp:ctrl_shift_toggle" ];

      switchingPolicy = "global";

      repeatDelay = 600;
      repeatRate = 25;
    };

    mice = [
      {
        name = "Logitech G304";
        vendorId = "046d";
        productId = "4074";

        acceleration = -0.5;
        accelerationProfile = "none";
      }
    ];
  };
}
