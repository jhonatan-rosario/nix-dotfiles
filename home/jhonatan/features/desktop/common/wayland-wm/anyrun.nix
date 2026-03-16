{
  inputs,
  pkgs,
  ...
}: {
  programs.anyrun = {
    enable = true;
    config = {
      # x = { fraction = 0.5; };
      # y = { fraction = 0.3; };
      # width = { fraction = 0.3; };
      # hideIcons = false;
      # ignoreExclusiveZones = false;
      # layer = "overlay";
      # hidePluginInfo = false;
      # closeOnClick = false;
      # showResultsImmediately = false;
      # maxEntries = null;

      x = {fraction = 0.5;};
      y = {absolute = 200;};
      width = {absolute = 600;};
      height = {absolute = 0;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = null;
      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.symbols
        inputs.anyrun.packages.${pkgs.system}.shell
        inputs.anyrun.packages.${pkgs.system}.dictionary
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.websearch
        inputs.anyrun.packages.${pkgs.system}.stdin
      ];
    };

    # Inline comments are supported for language injection into
    # multi-line strings with Treesitter! (Depends on your editor)
    extraCss =
      /*
      css
      */
      ''
               * {
          all: unset;
          font-size: 1.2rem;
        }

        #window,
        #match,
        #entry,
        #plugin,
        #main { background: transparent; }

        #match.activatable {
          border-radius: 10px;
          padding: .3rem .9rem;
          margin-top: .01rem;
        }
        #match.activatable:first-child { margin-top: 9px; }
        #match.activatable:last-child { margin-bottom: 1px; }

        #plugin:hover #match.activatable {
          border-radius: 10px;
          padding: .3rem;
          margin-top: .01rem;
          margin-bottom: 0;
        }


        #match:selected {
          color: @theme_selected_fg_color;
          background: @theme_selected_bg_color;
          border-radius: 8px;
        }

        #entry {
          border-radius: 8px;
          margin: .3rem;
          padding: .6rem 1.0rem;
          caret-color: white;
          font-size: 26px;
          font-weight: 500;
        }

        list > #plugin {
          border-top: 1px solid rgba(255,255,255,.11);
          margin: 0.3rem;
          padding-top: 4px;
          padding-left: 3px;
          font-weight: 400;
        }

        list > #plugin:first-child {
          margin-top: .3rem;
        }

        list > #plugin:last-child {
          margin-bottom: .3rem;
        }

        list > #plugin:hover {
          padding: .7rem;
        }

        box#main {
          border-color: rgba(255,255,255,0.2);
          color: white;
          border-width: 1px;
          border-style: solid;
          margin-top: 15px;
          background-color: rgba(0,0,0,0.6);
          border-radius: 22px;
          padding: .7rem;
        }

        zlabel#plugin {
          font-size:14px;
        }
      '';

    extraConfigFiles."websearch.ron".text = ''
      Config(
          prefix: "?",
          // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
          //
          // Custom engines can be defined as such:
          // Custom(
          //   name: "Searx",
          //   url: "searx.be/?q={}",
          // )
          //
          // NOTE: `{}` is replaced by the search query and `https://` is automatically added in front.
          engines: [Google]
        )
    '';
  };
}
