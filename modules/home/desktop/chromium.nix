{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;

    # Chromium keeps only the last --enable-features flag, so the Wayland one
    # the nixpkgs wrapper passes has to be repeated here.
    commandLineArgs = [
      "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,WaylandWindowDecorations"
    ];

    # home-manager's plasmaSupport only covers google-chrome,
    # so the plasma integration host is added by hand.
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];

    extensions = [
      { id = "fcoeoabgfenejglbffodgkkbkcdhcgfn"; } # claude
      { id = "ilcajpmogmhpliinlbcdebhbcanbghmd"; } # preact developer tools
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # google translate
      { id = "hpcgabhdlnapolkkjpejieegfpehfdok"; } # media harvest
      { id = "epcnnfbjfcgphgdmggkamkmgojdagdnn"; } # ublock
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # plasma integration
    ];
  };
}
