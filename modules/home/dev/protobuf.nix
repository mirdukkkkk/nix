{ pkgs, lib, ... }:
let
    protobuf-vsc = pkgs.vscode-utils.extensionFromVscodeMarketplace {
        name = "protobuf-vsc";
        publisher = "DrBlury";
        version = "1.6.14";
        sha256 = "sha256-wup+gWozELTO6jcNF5HZR1oRRwnGMor/PuEtdpRGz8g=";
    };
in
{
    home.packages = with pkgs; [ buf ];

    programs.vscode.profiles.default = {
        extensions = [ protobuf-vsc ];

        # Its bundled formatter's indent defaults are undocumented and would
        # fight this repo's 4-space convention (see pixel.proto), so keep
        # global editor.formatOnSave from touching .proto files.
        userSettings."[proto3]"."editor.formatOnSave" = false;
    };
}
