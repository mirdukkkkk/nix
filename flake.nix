{
    description = "NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nur.url = "github:nix-community/nur";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flameflag.url = "github:flameflag/nixpkgs/90cdc6283e794e7e276fa60f6d27b98a27454f15";
        iloader = {
            url = "github:mirdukkkkk/iloader";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nur, home-manager, ... } @ inputs:
    {
        overlays = import ./overlays;

        nixosConfigurations.miniature = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
                ./hosts/miniature
                nur.modules.nixos.default
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
