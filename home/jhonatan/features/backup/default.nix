{ config, pkgs, ... }:
let
  rcloneConfigPath = config.home.homeDirectory + "/.config/rclone/rclone.conf";
in
{
  # Garante que o rclone esteja disponível para o serviço
  home.packages = [ pkgs.rclone ];

  services.restic = {
    enable = true;
    backups = {
      home = {
        # O diretório que queremos salvar
        paths = [ "/persist/home/jhonatan" ];

        # O repositório usa o protocolo rclone
        # 'gdrive' é o nome que você deu no 'rclone config'
        # 'home' é a pasta que será criada no seu Google Drive
        repository = "rclone:gdrive:Backups/NixOS";

        # Arquivo de senha gerenciado pelo sops-nix
        passwordFile = config.sops.secrets.restic-password.path;

        # rclone.conf: O Restic precisa saber onde estão as credenciais do Google
        extraOptions = [
          "rclone.program=${pkgs.rclone}/bin/rclone"
          "rclone.args=serve restic --stdio --config=${rcloneConfigPath}"
        ];

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true; # Se o PC estiver desligado na hora, roda assim que ligar
        };

        # Limpeza automática para não lotar o Google Drive
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
        ];

        # Pastas para ignorar (cache e lixo)
        exclude = [
          "/home/jhonatan/.cache"
          "/home/jhonatan/.local/share/Trash"
          "/home/jhonatan/Downloads"
          "**/node_modules"
          "**/.direnv"
        ];
      };
    };
  };
}
