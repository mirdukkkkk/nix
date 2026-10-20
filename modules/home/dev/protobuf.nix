{ pkgs, ... }:
{
  home.packages = with pkgs; [ buf ];

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [ drblury.protobuf-vsc ];

    # Its bundled formatter's indent defaults are undocumented and would
    # fight this repo's 4-space convention (see pixel.proto), so keep
    # global editor.formatOnSave from touching .proto files.
    userSettings."[proto3]"."editor.formatOnSave" = false;
  };
}
