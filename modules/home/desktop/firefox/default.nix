{ pkgs, ... }:
let
    rycee = pkgs.nur.repos.rycee;

    betterfox = pkgs.fetchFromGitHub {
        owner = "yokoffing";
        repo = "Betterfox";
        rev = "152.0";
        hash = "sha256-QfisBzeoc8nUrgk/+PTvG9JATsVRWo7RDbohlxkNc+A=";
    };

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
        package = pkgs.unstable.firefox;
        configPath = ".mozilla/firefox";
        profiles.mrdk = {
            isDefault = true;

            preConfig = builtins.concatStringsSep "\n" [
                (builtins.readFile "${betterfox}/Fastfox.js")
                (builtins.readFile "${betterfox}/Securefox.js")
                (builtins.readFile "${betterfox}/Peskyfox.js")
                (builtins.readFile "${betterfox}/Smoothfox.js")
            ];

            settings = {
                "browser.startup.page" = 3;
                "browser.sessionstore.resume_from_crash" = true;
                "browser.sessionstore.restore_on_demand" = true;

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

                "privacy.clearOnShutdown.history" = false;
                "devtools.chrome.enabled" = true;
                "geo.enabled" = false;

                "middlemouse.paste" = false;
            };

            extensions.packages = nur-extensions ++ (builtins.attrValues generated-extensions);
        };
    };
}
