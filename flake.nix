{
  inputs = {
    # nix
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nur.url = "github:nix-community/nur";
    preservation.url = "github:nix-community/preservation";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # programs
    claude-code = {
      url = "github:sadjow/claude-code-nix?ref=v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox
    betterfox = {
      url = "github:yokoffing/betterfox";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      nur,
      preservation,
      nix-flatpak,
      lanzaboote,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations.miniature = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/miniature
          nur.modules.nixos.default
          preservation.nixosModules.preservation
          nix-flatpak.nixosModules.nix-flatpak
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";

              extraSpecialArgs = { inherit inputs self; };

              sharedModules = [
                plasma-manager.homeModules.plasma-manager
              ];

              users.mirdukkkkk = import ./home/mirdukkkkk;
            };
          }
        ];
      };
    };
}
