{ config, pkgs, ... }: {
  sops.secrets = {
    weather_display_name.sopsFile = ../../../secrets.yaml;
    weather_place_info.sopsFile = ../../../secrets.yaml;
    weather_provider.sopsFile = ../../../secrets.yaml;
  };

  programs.plasma.startup.startupScript."configure_weather" = {
    text = ''
      qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
        var allDesktops = desktops();
        for (var i = 0; i < allDesktops.length; i++) {
          var widgets = allDesktops[i].widgets();
          for (var j = 0; j < widgets.length; j++) {
            var w = widgets[j];
            if (w.type === 'org.kde.plasma.weather') {
              w.currentConfigGroup = ['WeatherStation'];
              w.writeConfig('placeDisplayName', '$(cat ${config.sops.secrets.weather_display_name.path})');
              w.writeConfig('placeInfo', '$(cat ${config.sops.secrets.weather_place_info.path})');
              w.writeConfig('provider', '$(cat ${config.sops.secrets.weather_provider.path})');
            }
          }
        }
      "
    '';
    priority = 4;
    runAlways = true;
  };

  programs.plasma.desktop = {
    widgets = [
      # ── Row 1: CPU (pie) + temp (on hover) ────────────────
      {
        systemMonitor = {
          position = { horizontal = 20; vertical = 20; };
          size = { width = 350; height = 200; };
          title = "CPU";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.piechart";
          showLegend = true;
          sensors = [
            { name = "cpu/all/usage"; color = "180,190,254"; label = "CPU %"; }
          ];
          totalSensors = [ "cpu/all/usage" ];
          textOnlySensors = [ "cpu/all/averageTemperature" ];
          range = { from = 0; to = 100; };
        };
      }

      # ── Row 1: RAM (pie) ──────────────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 390; vertical = 20; };
          size = { width = 350; height = 200; };
          title = "Memory";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.piechart";
          showLegend = true;
          sensors = [
            { name = "mem/physical/used"; color = "239,152,150"; label = "Used"; }
            { name = "mem/physical/available"; color = "150,200,150"; label = "Available"; }
          ];
          totalSensors = [ "mem/physical/percentage" ];
          textOnlySensors = [ "mem/physical/total" ];
        };
      }

      # ── Row 2: Per-core CPU (bar) ────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 20; vertical = 240; };
          size = { width = 350; height = 200; };
          title = "Cores";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.barchart";
          sensors = [
            { name = "cpu/cpu0/usage"; color = "180,190,254"; label = "Core 0"; }
            { name = "cpu/cpu1/usage"; color = "239,152,150"; label = "Core 1"; }
            { name = "cpu/cpu2/usage"; color = "150,200,150"; label = "Core 2"; }
            { name = "cpu/cpu3/usage"; color = "254,180,180"; label = "Core 3"; }
            { name = "cpu/cpu4/usage"; color = "180,254,180"; label = "Core 4"; }
            { name = "cpu/cpu5/usage"; color = "180,180,254"; label = "Core 5"; }
            { name = "cpu/cpu6/usage"; color = "254,254,180"; label = "Core 6"; }
            { name = "cpu/cpu7/usage"; color = "254,180,254"; label = "Core 7"; }
          ];
          range = { from = 0; to = 100; };
        };
      }

      # ── Row 2: RAM history (bar) ─────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 390; vertical = 240; };
          size = { width = 350; height = 200; };
          title = "RAM History";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.barchart";
          sensors = [
            { name = "mem/physical/used"; color = "150,200,150"; label = "Used"; }
          ];
          totalSensors = [ "mem/physical/used" ];
        };
      }

      # ── Row 3: Network (bar) ─────────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 20; vertical = 460; };
          size = { width = 350; height = 180; };
          title = "Network";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.barchart";
          sensors = [
            { name = "network/all/download"; color = "150,200,150"; label = "Down"; }
            { name = "network/all/upload"; color = "239,152,150"; label = "Up"; }
          ];
        };
      }

      # ── Row 4: Disk (pie) ────────────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 20; vertical = 660; };
          size = { width = 350; height = 180; };
          title = "Disk";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.piechart";
          showLegend = true;
          sensors = [
            { name = "disk/all/fillLevel"; color = "180,190,254"; label = "Used"; }
            { name = "disk/all/free"; color = "150,200,150"; label = "Free"; }
          ];
          totalSensors = [ "disk/all/fillLevel" ];
          range = { from = 0; to = 100; };
        };
      }

      # ── Row 5: Weather (placeholder — config location in GUI) ─
      {
        name = "org.kde.plasma.weather";
        position = { horizontal = 20; vertical = 860; };
        size = { width = 350; height = 180; };
        config = { };
      }
    ];

    icons = {
      arrangement = "topToBottom";
      alignment = "right";
      sorting.mode = "date";
    };
  };
}
