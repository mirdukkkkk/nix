{
    description = "NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nur.url = "github:nix-community/nur";
        impermanence.url = "github:nix-community/impermanence";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        molten.url = "github:pixelate-it/molten";
        iloader.url = "github:mirdukkkkk/iloader";
        beefetch.url = "github:mirdukkkkk/beefetch";
        claude-code.url = "github:sadjow/claude-code-nix?ref=v2";

        clawd-on-desk = {
            url = "github:rullerzhou-afk/clawd-on-desk/v0.13.0";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, nur, impermanence, home-manager, ... } @ inputs:
    {
        nixosConfigurations.miniature = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
                ./hosts/miniature
                nur.modules.nixos.default
                impermanence.nixosModules.impermanence
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;

                        extraSpecialArgs = { inherit inputs self; };

                        users.mirdukkkkk = import ./home/mirdukkkkk;
                    };
                }
            ];
        };
    };
}
