{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    openssl
    e2fsprogs
    parted
  ];
}
