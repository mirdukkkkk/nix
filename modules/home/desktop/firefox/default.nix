{
  config,
  pkgs,
  inputs,
  ...
}:
let
  rycee = pkgs.nur.repos.rycee;

  betterfox = inputs.betterfox;

  nur-extensions = with rycee.firefox-addons; [
    cookie-editor
    flagfox
    plasma-integration
    reduxdevtools
    sponsorblock
    ublock-origin
  ];
  generated-extensions = import ./extensions.nix {
    buildMozillaXpiAddon = rycee.lib.mozilla.mkBuildMozillaXpiAddon {
      inherit (pkgs) fetchurl stdenv;
    };
    inherit (pkgs) fetchurl lib stdenv;
  };
in
{
  home.packages = [ rycee.mozilla-addons-to-nix ];

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
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

        # Telemetry / data reporting
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

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

        # Devtools
        # Enables the Browser Console (privileged JS context) for extension/UI debugging.
        "devtools.chrome.enabled" = true;

        # Performance
        "gfx.webrender.all" = true;

        # Input / misc UX
        "general.autoScroll" = true;
        "middlemouse.paste" = false;
      };

      extensions.packages = nur-extensions ++ (builtins.attrValues generated-extensions);
    };
  };
}
