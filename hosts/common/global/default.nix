# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./optin-persistence.nix
    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./bootloader.nix
    ./nix-ld.nix
    ./networking.nix
    ./resolved.nix
    ./sops.nix
    ./tpm.nix
    ./fonts.nix
    ./upower.nix
  ]
  ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bkp";
    overwriteBackup = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  # Fix for qt6 plugins
  # TODO: maybe upstream this?
  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = [ "/lib/qt-6/plugins" ];
  };
}
