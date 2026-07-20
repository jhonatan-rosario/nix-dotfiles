{ pkgs, inputs, ... }:
{
  # install package
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # environment.persistence."/persist".directories = [
  #   ".local/share/noctalia"
  # ];
}
