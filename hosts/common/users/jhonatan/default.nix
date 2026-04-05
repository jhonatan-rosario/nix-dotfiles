{
  pkgs,
  config,
  ...
}:
let
  username = "jhonatan";
  hasLibvirt = config.virtualisation.libvirtd.enable;
  hasVirtManager = config.programs.virt-manager.enable;
in
{

  sops.secrets.jhonatan-password.neededForUsers = true;

  users.groups.${username} = {
    gid = 1000;
  };

  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.jhonatan-password.path;
    home = "/home/${username}";
    description = "Jhonatan";
    extraGroups = [
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
