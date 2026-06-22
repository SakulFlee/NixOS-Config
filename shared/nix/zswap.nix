{ ... }: {
  # Note: boot.resumeDevice needs to be set for hibernation to work!

  # ZRAM and ZSWAP are incompatible!
  zramSwap.enable = lib.mkForce false;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
  ];
}
