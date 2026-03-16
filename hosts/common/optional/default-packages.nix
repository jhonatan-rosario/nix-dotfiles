{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    onlyoffice-bin_latest
    # libreoffice
    openssl
    e2fsprogs
    parted
  ];
}
