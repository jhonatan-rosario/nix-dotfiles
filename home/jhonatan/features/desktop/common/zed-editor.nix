{
  # inputs,
  pkgs,
  ...
}:
# let
#   zed-editor = inputs.zed.packages.${pkgs.system}.default;
# in
{
  # home.packages = [
  #   zed-editor
  # ];
  #
  home.sessionVariables = {
    VISUAL = "zeditor -w";
  };

  home.sessionVariables = {
    EDITOR = "zeditor -w";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "dev.zed.Zed.desktop" ];
    };
  };

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;

    extraPackages = with pkgs; [
      nixd
      nixfmt
      dart
      # bun
      # git
      # ripgrep
      # fd
      # jq
      # biome
      # typescript-language-server
      # vscode-langservers-extracted
      # yaml-language-server
      # taplo
      # shellcheck
      # shfmt
    ];

    extensions = [
      "catppuccin" # theme
      "catppuccin-icons" # icon theme
      "nix"
      "sql"
      "toml"
      "dockerfile"
      # "docker-compose"
      "lua"
      "git-firefly"
    ];

    # mutableUserSettings = false;
    # mutableUserKeymaps = false;
    # mutableUserTasks = false;
    # mutableUserDebug = false;

    userSettings = {
      base_keymap = "VSCode";
      auto_update = false;
      vim_mode = false;

      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      icon_theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      telemetry = {
        metrics = false;
        diagnostics = false;
        anthropic_retention = false;
      };

      autosave = "off";
      format_on_save = "on";

      show_whitespaces = "selection";

      ui_font_size = 16;
      ui_font_family = ".ZedSans";
      buffer_font_size = 15;
      buffer_font_family = "JetBrains Mono";

      project_panel = {
        dock = "left";
      };

      agent = {
        dock = "right";
      };

      git_panel = {
        dock = "left";
      };

      outline_panel = {
        dock = "left";
      };

      collaboration_panel = {
        dock = "left";
      };

      file_scan_exclusions = [
        "**/.git"
        "**/.direnv"
        "**/node_modules"
        "**/.turbo"
        "**/dist"
        "**/.next"
      ];

      languages = {
        "Nix" = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
          format_on_save = "on";
          # format_on_save = {
          #   external = {
          #     command = "nixfmt";
          #   };
          # };
        };
      };
    };
  };

  home.persistence = {
    "/persist".directories = [
      ".local/share/zed/db"
      ".local/share/zed/external_agents"
      ".local/share/zed/languages"
      ".local/share/zed/extensions"
      ".config/zed/prompts"
      ".config/zed/snippets"
    ];
  };

}
