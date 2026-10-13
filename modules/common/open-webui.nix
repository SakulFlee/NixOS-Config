{ ... }: {
    services.open-webui = {
        enable = true;
        port = 30002;
        openFirewall = false;
    };
}
