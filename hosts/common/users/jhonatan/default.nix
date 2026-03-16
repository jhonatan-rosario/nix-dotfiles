{
  pkgs,
  config,
  ...
}: let
  username = "jhonatan";
  hasLibvirt = config.virtualisation.libvirtd.enable;
  hasVirtManager = config.programs.virt-manager.enable;
in {

  users.groups.${username} = {
    gid = 1000;
  };

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "changeme@123";
    description = "Jhonatan";
    extraGroups =
      [
        "${username}"
        "networkmanager"
        "input"
        "wheel"
        "video"
        "audio"
        "tss"
      ]
      ++ (pkgs.lib.optional (hasLibvirt && hasVirtManager) "libvirtd");
    shell = pkgs.fish;
  };
}
