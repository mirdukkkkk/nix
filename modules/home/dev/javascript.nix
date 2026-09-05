{ pkgs, config, ... }:
let
    bun = pkgs.bun.overrideAttrs (oldAttrs: rec {
        version = "1.4.1";
        src = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
            hash = "sha256-dMHDvufNmYUAyPlpzYlyNVrGoHIH6Uo57s4ZmbVv+r8=";
        };
    });
in
{
    home = {
        packages = [ pkgs.yarn-berry ];
        sessionPath = [ "${config.xdg.dataHome}/npm/bin" ];
    };

    programs = {
        npm = {
            enable = true;
            package = pkgs.nodejs_26;
            settings = {
                prefix = "${config.xdg.dataHome}/npm";
                logs-dir = "${config.xdg.dataHome}/npm/_logs";
                cache = "${config.xdg.cacheHome}/npm";
                save-exact = true;
                fund = false;
            };
        };
        yarn = {
            enable = true;
            settings = {
                cacheFolder = "${config.xdg.cacheHome}/yarn";
                virtualFolder = "${config.xdg.cacheHome}/yarn/__virtual__";
                globalFolder = "${config.xdg.dataHome}/yarn";
                enableProgressBars = true;
                enableTelemetry = false;
            };
        };
        bun = {
            enable = true;
            package = bun;
            settings = {
                telemetry = false;
                install = {
                    globalStore = true;
                    linker = "isolated";
                    minimumReleaseAge = 259200;
                    minimumReleaseAgeExcludes = [ "@types/bun" "typescript" ];
                    cache = {
                        dir = "${config.xdg.cacheHome}/bun";
                    };
                };
            };
        };
        vscode.profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                astro-build.astro-vscode
                prisma.prisma
                svelte.svelte-vscode
                unifiedjs.vscode-mdx
            ];

            userSettings = {
                "[javascript]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[javascriptreact]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typescript]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typescriptreact]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
            };
        };
    };
}
