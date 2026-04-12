{
  description = "Your new nix config";

  nixConfig = {
    builders-use-substitutes = true;
    extra-substituters = [ "https://noctalia.cachix.org" ];

    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default-linux";

    # Hardware
    hardware.url = "github:nixos/nixos-hardware/master";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    impermanence = {
      # https://github.com/nix-community/impermanence/pull/272#discussion_r2230796215
      url = "github:misterio77/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      home-manager,
      impermanence,
      sops-nix,
      disko,
      noctalia,
      nix-colors,
      nix-flatpak,
      antigravity-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      lib = nixpkgs.lib // home-manager.lib;

      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        }
      );
    in
    {
      inherit lib;

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        voyager = lib.nixosSystem {
          modules = [
            ./hosts/voyager
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager switch --flake .#your-username@your-hostname'

      # Disabled because home-manager is now a module of NixOS
      # homeConfigurations = {
      #   "jhonatan@voyager" = lib.homeManagerConfiguration {
      #     pkgs = pkgsFor.x86_64-linux; # Home-manager requires 'pkgs' instance
      #     modules = [
      #       ./home/jhonatan/voyager.nix
      #       ./home/jhonatan/nixpkgs.nix
      #     ];
      #     extraSpecialArgs = {
      #       inherit inputs outputs nix-colors;
      #     };
      #   };
      # };
    };
}
