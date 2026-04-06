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

    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

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
      noctalia,
      sops-nix,
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
      # systems = [
      #   "aarch64-linux"
      #   "i686-linux"
      #   "x86_64-linux"
      #   "aarch64-darwin"
      #   "x86_64-darwin"
      # ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      # forAllSystems = lib.genAttrs systems;
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

      # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        voyager = lib.nixosSystem {
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/voyager
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager switch --flake .#your-username@your-hostname'
      homeConfigurations = {
        "jhonatan@voyager" = lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.x86_64-linux.extend inputs.hyprpanel.overlay; # Home-manager requires 'pkgs' instance
          pkgs = pkgsFor.x86_64-linux; # Home-manager requires 'pkgs' instance
          # pkgs = import nixpkgs {
          #   inherit system;
          #   overlays = [
          #     inputs.hyprpanel.overlay
          #   ];
          # };
          modules = [
            nix-flatpak.homeManagerModules.nix-flatpak
            ./home/jhonatan/voyager.nix
            ./home/jhonatan/nixpkgs.nix
          ];
          extraSpecialArgs = {
            inherit inputs outputs nix-colors;
          };
        };
      };
    };
}
