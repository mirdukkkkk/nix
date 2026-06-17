{
    description = "NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nur.url = "github:nix-community/nur";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/3d940a534da0ba6bce60e345ff2c9c7b062087fb";
        discord-vk.url = "github:luckshiba/nixpkgs/discord-vk";

        iloader.url = "github:mirdukkkkk/iloader";
        beefetch.url = "github:mirdukkkkk/beefetch";
    };

    outputs = { self, nixpkgs, nur, home-manager, ... } @ inputs:
    {
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
