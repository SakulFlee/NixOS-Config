{ ... }: {
  programs.plasma.desktop = {
    widgets = [
      # ── CPU (bar chart) ──────────────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 20; vertical = 20; };
          size = { width = 350; height = 220; };
          title = "CPU";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.barchart";
          sensors = [
            { name = "cpu/all/usage"; color = "180,190,254"; label = "CPU %"; }
            { name = "cpu/all/averageTemperature"; color = "239,152,150"; label = "Temp"; }
            { name = "cpu/all/averageFrequency"; color = "150,200,150"; label = "Freq"; }
          ];
          totalSensors = [ "cpu/all/usage" ];
          textOnlySensors = [
            "cpu/all/averageTemperature"
            "cpu/all/averageFrequency"
          ];
          range = { from = 0; to = 100; };
        };
      }

      # ── Memory (pie chart) ─────────────────────────────
      {
        systemMonitor = {
          position = { horizontal = 390; vertical = 20; };
          size = { width = 350; height = 240; };
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

      # ── Disk (bar chart, preset) ────────────────────────
      {
        name = "org.kde.plasma.systemmonitor.diskusage";
        position = { horizontal = 760; vertical = 20; };
        size = { width = 350; height = 220; };
        config = {
          Appearance = {
            title = "Disk";
            showTitle = true;
            chartFace = "org.kde.ksysguard.barchart";
          };
        };
      }

      # ── Network (bar chart, preset) ─────────────────────
      {
        name = "org.kde.plasma.systemmonitor.net";
        position = { horizontal = 20; vertical = 280; };
        size = { width = 350; height = 220; };
        config = {
          Appearance = {
            title = "Network";
            showTitle = true;
            chartFace = "org.kde.ksysguard.barchart";
          };
        };
      }

      # ── Battery ─────────────────────────────────────────
      {
        battery = {
          position = { horizontal = 390; vertical = 280; };
          size = { width = 200; height = 200; };
          showPercentage = true;
        };
      }

      # ── Weather (placeholder — configure location in GUI) ─
      {
        name = "org.kde.plasma.weather";
        position = { horizontal = 610; vertical = 280; };
        size = { width = 300; height = 350; };
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
