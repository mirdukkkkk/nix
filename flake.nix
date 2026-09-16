{
  inputs = {
    # nix
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    preservation.url = "github:nix-community/preservation";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # programs
    molten.url = "github:pixelate-it/molten";
    iloader.url = "github:mirdukkkkk/iloader";
    beefetch.url = "github:mirdukkkkk/beefetch";
    claude-code.url = "github:sadjow/claude-code-nix?ref=v2";

    # firefox
    betterfox = {
      url = "github:yokoffing/betterfox";
      flake = false;
    };

    # claude skills/plugins
    caveman = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };
    security-audit-skill = {
      url = "github:cloudflare/security-audit-skill";
      flake = false;
    };
    ascii-art = {
      url = "github:mirdukkkkk/ascii-art";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      iloader,
      preservation,
      nix-flatpak,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.miniature = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/miniature
          nur.modules.nixos.default
          iloader.nixosModules.default
          preservation.nixosModules.preservation
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";

              extraSpecialArgs = { inherit inputs self; };

              users.mirdukkkkk = import ./home/mirdukkkkk;
            };
          }
        ];
      };
    };
}
