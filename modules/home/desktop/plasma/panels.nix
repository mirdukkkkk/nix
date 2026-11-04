{ pkgs, ... }:
{
  home.packages = [ pkgs.plasma-panel-colorizer ];

  programs.plasma.panels = [
    {
      location = "top";
      screen = 0;
      height = 32;
      floating = false;
      lengthMode = "fill";
      opacity = "opaque";
      widgets = [
        "luisbocanegra.panel.colorizer"
        "org.kde.plasma.simplekickoff"
        {
          name = "org.kde.plasma.catwalkr";
          config.General = {
            idle = "5";
            type = "1";
          };
        }
        {
          name = "org.kde.windowtitle.Fork";
          config.General = {
            customText = "true";
            iconSize = "38";
            showIcon = "false";
            textDefault = "No Application";
            useActivityIcon = "false";
          };
        }
        "org.kde.plasma.panelspacer"
        {
          digitalClock = {
            date.enable = false;
            time.format = "24h";
            font.family = "Comic Relief";
          };
        }
        "org.kde.plasma.panelspacer"
        {
          systemTray.items = {
            shown = [
              "org.kde.plasma.notifications"
              "org.kde.plasma.volume"
              "steam"
            ];
            hidden = [
              "org.kde.plasma.devicenotifier"
              "org.kde.plasma.mediacontroller"
              "org.kde.plasma.keyboardindicator"
            ];
          };
        }
        {
          name = "zayron.simple.separator";
          config.General.lengthMargin = "5";
        }
        {
          name = "org.kde.plasma.resources-monitor";
          config = {
            Appearance = {
              autoFontAndSize = "false";
              fontFamily = "Comic Relief";
              fontSize = "6";
              fontStyleName = "Regular";
              fontWeight = "400";
              keepFontSize = "true";
            };
            General.graphs = ''[{"_v":3,"type":"network","sizes":[50,-1],"colors":["highlightColor","positiveTextColor"],"sensorsType":[false,"kibibyte"],"uplimits":[10000,10000],"ignoredInterfaces":[],"icons":true},{"_v":3,"type":"memory","sizes":[50,-1],"colors":["highlightColor","negativeTextColor"],"sensorsType":["physical","swap"],"thresholds":[70,90]},{"_v":3,"type":"cpu","sizes":[50,-1],"colors":["highlightColor","textColor","textColor"],"sensorsType":["usage","classic",false],"clockAggregator":"average","eCoresCount":0,"thresholds":[85,105]}]'';
          };
        }
        {
          name = "zayron.simple.separator";
          config.General.lengthMargin = "5";
        }
        "org.kde.plasma.keyboardlayout"
        "org.kde.plasma.colorpicker"
        "org.kde.plasma.clipboard"
      ];
    }

    {
      location = "bottom";
      screen = 0;
      height = 64;
      floating = true;
      lengthMode = "fit";
      alignment = "center";
      hiding = "dodgewindows";
      opacity = "opaque";
      widgets = [
        "org.kde.plasma.kickerdash"
        {
          name = "zayron.simple.separator";
          config.General.lengthMargin = "5";
        }
        {
          iconTasks.launchers = [
            "applications:org.kde.dolphin.desktop"
            "applications:code.desktop"
            "applications:spotify.desktop"
            "applications:kitty.desktop"
            "applications:firefox.desktop"
            "applications:discord.desktop"
          ];
        }
        {
          name = "zayron.simple.separator";
          config.General.lengthMargin = "5";
        }
        "org.kde.plasma.trash"
      ];
    }
  ];
}
