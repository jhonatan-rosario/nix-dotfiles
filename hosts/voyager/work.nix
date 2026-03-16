{config, ...}: {
  config.system.activationScripts.makeVaultWardenDir = lib.stringAfter ["usr"] ''
    mkdir -p /usr/share/univale
  '';
}
