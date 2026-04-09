{
  pkgs,
  config,
  ...
}:
let
  username = "jhonatan";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
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
    extraGroups =
      ifTheyExist [
        "${username}"
        "networkmanager"
        "input"
        "wheel"
        "video"
        "audio"
        "tss"
        "docker"
        "podman"
        "plugdev"
        "kvm"
        "libvirt"
        "git"
      ]
      ++ (pkgs.lib.optional (hasLibvirt && hasVirtManager) "libvirtd");
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
  };

  home-manager.users.jhonatan = import ../../../../home/jhonatan/${config.networking.hostName}.nix;
}
