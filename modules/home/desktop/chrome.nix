{
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "fcoeoabgfenejglbffodgkkbkcdhcgfn"; } # claude
      { id = "ilcajpmogmhpliinlbcdebhbcanbghmd"; } # preact developer tools
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # google translate
      { id = "dcpelmafllhhdcbiegigphjnbgnolkgm"; } # x/twitter content backup tool
      { id = "epcnnfbjfcgphgdmggkamkmgojdagdnn"; } # ublock
    ];
  };
}
