{ pkgs, ... }:
{
    home.packages = with pkgs; [
        (writeShellScriptBin "java17"
            "exec ${javaPackages.compiler.temurin-bin.jre-17}/bin/java \"$@\"")

        (writeShellScriptBin "java21"
            "exec ${javaPackages.compiler.temurin-bin.jre-21}/bin/java \"$@\"")
    ];
}