{
  pkgs,
  lib,
  config,
  ...
}:
let
  noctalia = "noctalia-shell ipc call";
  username = config.home.username;
  userId = "1000";
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
    extraPackages = with pkgs; [
      dragon-drop
      glib
    ];
    enableFishIntegration = true;
    shellWrapperName = "yy";
    initLua = ''
      require("gvfs"):setup({
        -- (Optional) Allowed keys to select device.
        -- which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",

        -- (Optional) Table of blacklisted devices. These devices will be ignored in any actions
        -- List of device properties to match, or a string to match the device name:
        -- https://github.com/boydaihungst/gvfs.yazi/blob/master/main.lua#L144
        blacklist_devices = { { scheme = "file" } },

        -- (Optional) Save file.
        -- Default: ~/.config/yazi/gvfs.private
        save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",

        -- (Optional) Save file for automount devices. Use with `automount-when-cd` action.
        -- Default: ~/.config/yazi/gvfs_automounts.private
        save_path_automounts = os.getenv("HOME") .. "/.config/yazi/gvfs_automounts.private",

        -- (Optional) Input box position.
        -- Default: { "top-center", y = 3, w = 60 },
        -- Position, which is a table:
        -- 	`1`: Origin position, available values: "top-left", "top-center", "top-right",
        -- 	     "bottom-left", "bottom-center", "bottom-right", "center", and "hovered".
        --         "hovered" is the position of hovered file/folder
        -- 	`x`: X offset from the origin position.
        -- 	`y`: Y offset from the origin position.
        -- 	`w`: Width of the input.
        -- 	`h`: Height of the input.
        input_position = { "center", y = 0, w = 60 },

        -- (Optional) Select where to save passwords.
        -- Default: nil
        -- Available options: "keyring", "pass", or nil
        password_vault = "pass",

        -- (Optional) Only need if you set password_vault = "pass"
        -- Read the guide at SECURE_SAVED_PASSWORD.md to get your key_grip
        key_grip = "409329590DC265A62A66F90FF1A4CDB83D2686B8",

        -- (Optional) Auto-save password after mount.
        -- Default: false
        save_password_autoconfirm = false,
        -- (Optional) mountpoint of gvfs. Default: /run/user/USER_ID/gvfs
        -- On some system it could be ~/.gvfs
        -- You can't decide this path, it will be created automatically. Only changed if you know where gvfs mountpoint is.
        -- Use command `ps aux | grep gvfs` to search for gvfs process and get the mountpoint path.
        -- root_mountpoint = (os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. ya.uid())) .. "/gvfs"
      })
    '';
    settings = {
      mgr = {
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };

      plugin = {
        prepend_preloaders = [
          {
            url = "/run/user/${userId}/gvfs/**/*";
            run = "noop";
          }
          {
            url = "/run/media/${username}/**/*";
            run = "noop";
          }
        ];

        prepend_previewers = [
          # Allow to preview folder.
          {
            url = "*/";
            run = "folder";
          }

          # Do not previewing files in mounted locations.
          # Uncomment the line below to allow previewing text files.
          # { mime = "{text/*,application/x-subrip}"; run = "code"; },

          # Using absolute path.
          {
            url = "/run/user/${userId}/gvfs/**/*";
            run = "noop";
          }

          # For mounted hard disk/drive.
          {
            url = "/run/media/${username}/**/*";
            run = "noop";
          }
        ];
      };

      opener = {
        set-wallpaper = [
          {
            run = "${noctalia} wallpaper set %s1";
            for = "linux";
            desc = "Set as wallpaper";
          }
        ];
      };
      open = {
        prepend_rules = [
          {
            mime = "image/*";
            use = [
              "set-wallpaper"
              "open"
            ];
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "!";
          for = "unix";
          run = "shell \"$SHELL\" --block";
          desc = "Open $SHELL here";
        }
        {
          on = "<Enter>";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "p";
          run = "plugin smart-paste";
          desc = "Paste into the hovered directory or CWD";
        }
        {
          on = "<C-n>";
          run = "shell -- dragon-drop -x -i -T %s1";
          desc = "Dragon Drop";
        }
        {
          on = "y";
          run = [
            "shell -- for path in %s; do echo file://$path; done | wl-copy -t text/uri-list"
            "yank"
          ];
        }
        # Mount
        {
          on = [
            "M"
            "m"
          ];
          run = "plugin gvfs -- select-then-mount";
          desc = "Select device then mount";
        }
        # or this if you want to jump to mountpoint after mounted
        {
          on = [
            "M"
            "M"
          ];
          run = "plugin gvfs -- select-then-mount --jump";
          desc = "Select device to mount and jump to its mount point";
        }
        # This will remount device under current working directory (cwd)
        #   -> cwd = /run/user/1000/gvfs/DEVICE_1/FOLDER_A
        #   -> device mountpoint = /run/user/1000/gvfs/DEVICE_1
        #   -> remount this DEVIEC_1 if needed
        {
          on = [
            "M"
            "R"
          ];
          run = "plugin gvfs -- remount-current-cwd-device";
          desc = "Remount device under cwd";
        }

        {
          on = [
            "M"
            "u"
          ];
          run = "plugin gvfs -- select-then-unmount";
          desc = "Select device then unmount";
        }

        # Also support force unmount/eject.
        #   -> Ignore outstanding file operations when unmounting or ejecting
        {
          on = [
            "M"
            "U"
          ];
          run = "plugin gvfs -- select-then-unmount --eject --force";
          desc = "Select device then force to eject/unmount";
        }

        # Add Scheme/Mount URI:
        #   -> Available schemes: mtp, gphoto2, smb, sftp, ftp, nfs, dns-sd, dav, davs, dav+sd, davs+sd, afp, afc, sshfs
        #   -> Read more about the schemes here: https://wiki.gnome.org/Projects(2f)gvfs(2f)schemes.html
        #   -> Explain about the scheme:
        #       -> If it shows like this: {ftp,ftps,ftpis}://[user@]host[:port]
        #       -> All of the value within [] is optional. For values within {}, you must choose exactly one. All others are required.
        #       -> empty [user] or "anonymous" user is anonymous user in (ftp)
        #           -> ftp://anonymous@192.168.1.2:9999 -> skip user input step.
        #           -> ftp://192.168.1.2:9999 -> input empty value in user input box.
        #       -> Example: {ftp,ftps,ftpis}://[user@]host[:port] => ip and port: "ftp://myusername@192.168.1.2:9999" or domain: "ftps://myusername@github.com"
        #       -> More examples: smb://user@192.168.1.2/share, smb://WORKGROUP;user@192.168.1.2/share, sftp://user@192.168.1.2/, ftp://192.168.1.2/
        # !WARNING: - Scheme/Mount URI shouldn't contain password.
        #           - Google Drive, One drive are listed automatically via GNOME Online Accounts (GOA). Avoid adding them.
        #           - MTP, GPhoto2, AFC, Hard disk/drive, fstab with x-gvfs-show are also listed automatically. Avoid adding them.
        #           - SSH, SFTP, FTP(s), AFC, DNS_SD now support [/share]. For example: sftp://user@192.168.1.2/home/user_name -> /share = /home/user_name
        #           - ssh:// is alias for sftp://.
        #             -> {sftp,ssh}://[user@]host[:port]. Host can be Host alias in .ssh/config file, ip or domain.
        #             -> For example (home is Host alias in .ssh/config file: Host home):
        #                  -> ssh://user_name@home/home/user_name -> this will mount root path, but jump to subfolder /home/user_name
        #                  -> sftp://user_name@192.168.1.2/home/user_name -> same as above but with ip
        #                  -> sftp://user_name@192.168.1.2:9999/home/user_name -> same as above but with ip and port
        {
          on = [
            "M"
            "a"
          ];
          run = "plugin gvfs -- add-mount";
          desc = "Add a GVFS mount URI";
        }

        # Edit a Scheme/Mount URI
        #   -> Will clear saved passwords for that mount URI.
        {
          on = [
            "M"
            "e"
          ];
          run = "plugin gvfs -- edit-mount";
          desc = "Edit a GVFS mount URI";
        }

        # Remove a Scheme/Mount URI
        #   -> Will clear saved passwords for that mount URI.
        {
          on = [
            "M"
            "r"
          ];
          run = "plugin gvfs -- remove-mount";
          desc = "Remove a GVFS mount URI";
        }

        # Jump
        {
          on = [
            "g"
            "m"
          ];
          run = "plugin gvfs -- jump-to-device";
          desc = "Select device then jump to its mount point";
        }
        # If you use `x-systemd.automount` in /etc/fstab or manually added automount unit,
        # then you can use `--automount` argument to auto mount device before jump.
        # Otherwise it won't show up in the jump list.
        # {
        #   on = [
        #     "g"
        #     "m"
        #   ];
        #   run = "plugin gvfs -- jump-to-device --automount";
        #   desc = "Automount then select device to jump to its mount point";
        # }
        {
          on = [
            "`"
            "`"
          ];
          run = "plugin gvfs -- jump-back-prev-cwd";
          desc = "Jump back to the position before jumped to device";
        }

        # Automount (This is different from `x-systemd.automount` in /etc/fstab)
        #   -> Hover over any file/folder under a mounted device then run `automount-when-cd` action to enable automount when cd/jump for that device.
        #   -> When you cd/jump to unmounted device mountpoint or its sub folder, this will auto-mount the device before jump.
        #   -> Works with any command or any bookmark plugin that change cwd. For example, use `yamb` to add bookmarks and jump to them, use yazi's built-in `cd` `back` `forward` commands:

        #   -> { on = [ "m", "a" ], run = [ "plugin yamb -- save", "plugin gvfs -- automount-when-cd" ], desc = "Add bookmark and enable automount when cd"}
        {
          on = [
            "M"
            "t"
          ];
          run = "plugin gvfs -- automount-when-cd";
          desc = "Enable automount when cd to device under cwd";
        }
        {
          on = [
            "M"
            "T"
          ];
          run = "plugin gvfs -- automount-when-cd --disabled";
          desc = "Disable automount when cd to device under cwd";
        }
      ];

      input.prepend_keymap = [
        {
          on = "<Esc>";
          run = "close";
          desc = "Cancel input";
        }
      ];
    };
    plugins = with pkgs.yaziPlugins; {
      inherit full-border;
      inherit smart-enter;
      inherit smart-paste;
      inherit gvfs;
    };
  };

  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];

    config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
    };
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
    enable = true;
    force = true;
    executable = true;
    text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      create_help_file=1
      env=TERMCMD='ghostty --title=filechooser -e'
      env=PATH="$PATH:/run/current-system/sw/bin"
      open_mode=suggested
      save_mode=last
    '';
  };

  home.persistence."/persist".files = [
    ".config/yazi/gvfs.private"
    ".config/yazi/gvfs_automounts.private"
  ];
}
