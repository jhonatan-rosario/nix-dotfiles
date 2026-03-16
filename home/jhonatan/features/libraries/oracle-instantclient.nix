{pkgs, ...}: {
  home.packages = with pkgs; [
    oracle-instantclient
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = [pkgs.oracle-instantclient];
  };
}
