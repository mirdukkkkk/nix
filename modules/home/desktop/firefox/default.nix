{
  config,
  pkgs,
  inputs,
  ...
}:
let
  rycee = pkgs.nur.repos.rycee;
  mirdukkkkk = pkgs.nur.repos.mirdukkkkk;

  betterfox = inputs.betterfox;

  nur-extensions = with rycee.firefox-addons; [
    cookie-editor
    flagfox
    plasma-integration
    reduxdevtools
    sponsorblock
    ublock-origin
  ];
  honeycomb-extensions = with mirdukkkkk.firefox-addons; [
    indicatetls
    media-harvest
    preact-devtools
    resourceoverride
  ];
in
{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    # Betterfox's Securefox.js already flips the telemetry prefs; policies
    # additionally lock them so they can't be re-enabled from about:config.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      # Add-ons come from Nix; stops self-updating ones (e.g. media-harvest's update_url).
      ExtensionUpdate = false;
    };
    profiles.mrdk = {
      isDefault = true;

      preConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${betterfox}/Fastfox.js")
        (builtins.readFile "${betterfox}/Securefox.js")
        (builtins.readFile "${betterfox}/Peskyfox.js")
        (builtins.readFile "${betterfox}/Smoothfox.js")
      ];

      search = {
        default = "google";
        force = true;
        engines = {
          GitHub = {
            urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
            icon = "https://github.com/fluidicon.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
            definedAliases = [ "@gh" ];
          };
          "Nix Packages" = {
            urls = [ { template = "https://search.nixos.org/packages?type=packages&query={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
        };
      };

      settings = {
        # Startup / session
        "browser.startup.page" = 3;
        "browser.sessionstore.resume_from_crash" = true;
        "browser.sessionstore.restore_on_demand" = true;

        # Privacy
        "privacy.clearOnShutdown.history" = false;
        "geo.enabled" = false;
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;

        # Sync: keep identity, skip syncing extensions (managed by Nix instead).
        "services.sync.username" = config.my.identity.email;
        "services.sync.engine.addons" = false;

        # Extensions: managed by Nix, don't self-update.
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;

        # Downloads: 2 = use browser.download.dir instead of ~/Downloads.
        "browser.download.folderList" = 2;
        "browser.download.dir" = "/srv/nfs/downloads";

        # Devtools
        # Enables the Browser Console (privileged JS context) for extension/UI debugging.
        "devtools.chrome.enabled" = true;

        # Performance
        "gfx.webrender.all" = true;

        # Input / misc UX
        "general.autoScroll" = true;
        "middlemouse.paste" = false;
        "browser.tabs.allowTabDetach" = false;
      };

      extensions.packages = nur-extensions ++ honeycomb-extensions;
    };
  };
}
