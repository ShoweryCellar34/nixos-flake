{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url                    = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url                    = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, stylix, home-manager, ... }@inputs: {
    nixosConfigurations.MSI-Katana-15-B13V-NixOS = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs         = true;
          home-manager.useUserPackages       = true;
          home-manager.backupFileExtension   = "hmbackup";
          home-manager.users.ShoweryCellar34 = import ./home.nix;

          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
        }
      ];
    };
  };
}
