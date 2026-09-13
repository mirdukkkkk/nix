{ pkgs, ... }:
{
    home.packages = with pkgs; [
        (python3.withPackages(ps: with ps; [
            virtualenv

            pillow
        ]))

        ruff
    ];

    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [
            ms-python.python
            charliermarsh.ruff
        ];

        userSettings."[python]" = {
            "editor.defaultFormatter" = "charliermarsh.ruff";
            "editor.codeActionsOnSave" = {
                "source.organizeImports" = true;
                "source.fixAll" = true;
            };
        };
    };
}
