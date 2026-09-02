{ config, pkgs, ... }:
let
  resticRepository = "rclone:gdrive:Backups/NixOS";
  resticPasswordFile = config.sops.secrets.restic-password.path;
  rcloneConfigPath = config.home.homeDirectory + "/.config/rclone/rclone.conf";
in
{
  # Garante que o rclone e o restic estejam disponíveis no terminal (CLI)
  home.packages = [
    pkgs.rclone
    pkgs.restic
  ];

  # Variáveis de ambiente para usar o restic na linha de comando sem digitar repositório ou senha
  home.sessionVariables = {
    RESTIC_REPOSITORY = resticRepository;
    RESTIC_PASSWORD_FILE = resticPasswordFile;
  };

  # Declarar o segredo gerenciado pelo sops-nix
  sops.secrets.restic-password = { };

  services.restic = {
    enable = true;
    backups = {
      home = {
        # O diretório que queremos salvar
        paths = [ "/persist/home/jhonatan" ];

        # O repositório usa o protocolo rclone
        # 'gdrive' é o nome que você deu no 'rclone config'
        # 'Backups/NixOS' é a pasta que será criada no seu Google Drive
        repository = resticRepository;

        # Arquivo de senha gerenciado pelo sops-nix
        passwordFile = resticPasswordFile;

        # Cria o repositório no destino automaticamente caso ainda não exista
        initialize = true;

        # Garante que o restic encontre o executável do rclone
        extraOptions = [
          "rclone.program=${pkgs.rclone}/bin/rclone"
        ];

        # Informa ao rclone onde está o seu arquivo de configuração
        rcloneOptions = {
          config = rcloneConfigPath;
        };

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

        # Pastas e padrões para ignorar (cache, lixo, dependências e artefatos de build)
        exclude = [
          # Caches e temporários do sistema
          "/persist/home/jhonatan/.cache"
          "/persist/home/jhonatan/.local/share/Trash"
          "/persist/home/jhonatan/Downloads"

          # Runtimes e caches pesados de desenvolvimento
          "/persist/home/jhonatan/.gradle"
          "/persist/home/jhonatan/Android/Sdk"
          "/persist/home/jhonatan/.config/.android"
          "/persist/home/jhonatan/.pub-cache"
          "/persist/home/jhonatan/.local/share/flatpak"
          "/persist/home/jhonatan/.local/share/zed/languages"

          # Cache de mídia e IndexedDB de sites do navegador (WhatsApp Web, etc.)
          "/persist/home/jhonatan/.config/zen/*/storage/default"

          # Artefatos de compilação em projetos (dev)
          "**/node_modules"
          "**/.direnv"
          "**/build"
          "**/.dart_tool"
          "**/.turbo"
          "**/dist"
          "**/.next"
          "**/.nuxt"
          "**/.venv"
          "**/__pycache__"
          "**/target"
        ];
      };
    };
  };
}
