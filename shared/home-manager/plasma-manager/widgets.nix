{ config, pkgs, ... }:
{
  home.file.".config/plasma-org.kde.plasma.desktop-appletsrc".text = ''
    [ActionPlugins][0]
    MiddleButton;NoModifier=org.kde.paste
    RightButton;NoModifier=org.kde.contextmenu

    [ActionPlugins][1]
    RightButton;NoModifier=org.kde.contextmenu

    [Containments][1]
    ItemGeometries-1920x1080=Applet-438:0,0,192,256,0;Applet-432:0,640,368,336,0;Applet-434:0,256,192,192,0;Applet-435:192,0,192,256,0;Applet-437:192,256,192,192,0;
    ItemGeometriesHorizontal=Applet-438:0,0,192,256,0;Applet-432:0,640,368,336,0;Applet-434:0,256,192,192,0;Applet-435:192,0,192,256,0;Applet-437:192,256,192,192,0;
    activityId=3eb3453b-1e81-48ad-a354-1e4f44494b2d
    formfactor=0
    immutability=1
    lastScreen=0
    location=0
    plugin=org.kde.plasma.folder
    wallpaperplugin=org.kde.image

    # --- WEATHER WIDGET ---
    [Containments][1][Applets][432]
    immutability=1
    plugin=org.kde.plasma.weather

    [Containments][1][Applets][432][Configuration][ConfigDialog]
    DialogHeight=630
    DialogWidth=810

    [Containments][1][Applets][432][Configuration][WeatherStation]
    placeDisplayName=Moenchengladbach
    placeInfo=Moenchengladbach|10403
    provider=dwd

    # --- NETWORK MONITOR ---
    [Containments][1][Applets][434]
    immutability=1
    plugin=org.kde.plasma.systemmonitor.net

    [Containments][1][Applets][434][Configuration]
    CurrentPreset=org.kde.plasma.systemmonitor

    [Containments][1][Applets][434][Configuration][Appearance]
    chartFace=org.kde.ksysguard.linechart
    title=Network Speed

    [Containments][1][Applets][434][Configuration][SensorColors]
    network/all/download=61,174,233
    network/all/upload=233,120,61

    [Containments][1][Applets][434][Configuration][Sensors]
    highPrioritySensorIds=["network/all/download","network/all/upload"]

    # --- MEMORY MONITOR ---
    [Containments][1][Applets][435]
    immutability=1
    plugin=org.kde.plasma.systemmonitor.memory

    [Containments][1][Applets][435][Configuration]
    CurrentPreset=org.kde.plasma.systemmonitor

    [Containments][1][Applets][435][Configuration][Appearance]
    chartFace=org.kde.ksysguard.piechart
    title=Memory Usage

    [Containments][1][Applets][435][Configuration][SensorColors]
    memory/physical/used=61,174,233

    [Containments][1][Applets][435][Configuration][Sensors]
    highPrioritySensorIds=["memory/physical/used"]
    lowPrioritySensorIds=["memory/physical/total"]
    totalSensors=["memory/physical/usedPercent"]

    # --- DISK MONITOR ---
    [Containments][1][Applets][437]
    immutability=1
    plugin=org.kde.plasma.systemmonitor.diskactivity

    [Containments][1][Applets][437][Configuration]
    CurrentPreset=org.kde.plasma.systemmonitor

    [Containments][1][Applets][437][Configuration][Appearance]
    chartFace=org.kde.ksysguard.linechart
    title=Hard Disk Activity

    [Containments][1][Applets][437][Configuration][SensorColors]
    disk/all/read=233,120,61
    disk/all/write=61,174,233

    [Containments][1][Applets][437][Configuration][Sensors]
    highPrioritySensorIds=["disk/all/write","disk/all/read"]

    # --- CPU MONITOR ---
    [Containments][1][Applets][438]
    immutability=1
    plugin=org.kde.plasma.systemmonitor.cpu

    [Containments][1][Applets][438][Configuration]
    CurrentPreset=org.kde.plasma.systemmonitor

    [Containments][1][Applets][438][Configuration][Appearance]
    chartFace=org.kde.ksysguard.piechart
    title=Total CPU Use

    [Containments][1][Applets][438][Configuration][SensorColors]
    cpu/all/usage=61,174,233

    [Containments][1][Applets][438][Configuration][Sensors]
    highPrioritySensorIds=["cpu/all/usage"]
    lowPrioritySensorIds=["cpu/all/cpuCount","cpu/all/coreCount"]
    totalSensors=["cpu/all/usage"]

    # --- GENERAL & WALLPAPER SETTINGS ---
    [Containments][1][General]
    alignment=1
    arrangement=1
    sortMode=2
    url=file:///home/sakulflee/Sync/Desktop

    [Containments][1][Wallpaper][org.kde.image][General]
    Image=file:///usr/share/wallpapers/cachyos-wallpapers/PurpleFeathers.png
  '';
}
