{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    gdb
  ];

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
    ];

    userSettings =
      let
        cppFormatter = {
          "editor.defaultFormatter" = "ms-vscode.cpptools";
        };
      in
      {
        "[c]" = cppFormatter;
        "[cpp]" = cppFormatter;

        "C_Cpp.clang_format_path" = "${pkgs.clang-tools}/bin/clang-format";
      };
  };
}
