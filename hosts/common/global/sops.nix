{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  userPath = config.users.users.jhonatan.home;
  hasOptinPersistence = config.environment.persistence ? "/persist";
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "${lib.optionalString hasOptinPersistence "/persist"}/var/lib/sops-nix/age-key.txt";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
