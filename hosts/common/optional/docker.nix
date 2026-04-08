{
  pkgs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  environment.systemPackages = with pkgs; [ docker-compose ];

  users.users.jhonatan.extraGroups = [ "docker" ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/docker"
    ];
  };

}
