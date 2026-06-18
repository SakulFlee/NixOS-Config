{ ... }: {
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

      # ── Row 1: RAM (pie, preset) ─────────────────────────
      {
        name = "org.kde.plasma.systemmonitor.memory";
        position = { horizontal = 390; vertical = 20; };
        size = { width = 350; height = 200; };
        config = {
          Appearance = {
            title = "Memory";
            showTitle = true;
            chartFace = "org.kde.ksysguard.piechart";
          };
        };
      }

      # ── Row 2: Per-core CPU (preset) ─────────────────────
      {
        name = "org.kde.plasma.systemmonitor.coreusage";
        position = { horizontal = 20; vertical = 240; };
        size = { width = 350; height = 200; };
        config = {
          Appearance = {
            title = "Cores";
            showTitle = true;
          };
        };
      }

      # ── Row 2: RAM history (line chart) ─────────────────
      {
        systemMonitor = {
          position = { horizontal = 390; vertical = 240; };
          size = { width = 350; height = 200; };
          title = "RAM History";
          showTitle = true;
          displayStyle = "org.kde.ksysguard.linechart";
          sensors = [
            { name = "mem/physical/used"; color = "150,200,150"; label = "Used"; }
          ];
          totalSensors = [ "mem/physical/used" ];
        };
      }

      # ── Row 3: Network (preset) ──────────────────────────
      {
        name = "org.kde.plasma.systemmonitor.net";
        position = { horizontal = 20; vertical = 460; };
        size = { width = 350; height = 180; };
        config = {
          Appearance = {
            title = "Network";
            showTitle = true;
          };
        };
      }

      # ── Row 4: Disk (pie, preset) ────────────────────────
      {
        name = "org.kde.plasma.systemmonitor.diskusage";
        position = { horizontal = 20; vertical = 660; };
        size = { width = 350; height = 180; };
        config = {
          Appearance = {
            title = "Disk";
            showTitle = true;
            chartFace = "org.kde.ksysguard.piechart";
          };
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
