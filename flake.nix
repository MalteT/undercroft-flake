{
  description = "Undercroft Linux Wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    src = pkgs.fetchzip {
      url = "https://download.rakeingrass.com/full/undercroft_windows_i110.zip";
      hash = "sha256-veRWUaF2LMcESWXmtRMQdTwavWzbt2kgpoIZOpTm7K0=";
    };

    runShContent = builtins.readFile (
      pkgs.runCommand "run.sh" {} ''
        ${pkgs.argbash}/bin/argbash ${./run.m4} -o $out
      ''
    );

    pkg = pkgs.writeShellApplication {
      name = "undercroft-run";
      runtimeInputs = [
        pkgs.unionfs-fuse
        pkgs.coreutils
        pkgs.wine
        pkgs.winetricks
        pkgs.gamescope
        pkgs.libstrangle
      ];
      text = builtins.replaceStrings ["@SRC@"] [(builtins.toString src)] runShContent;
    };
  in {
    packages.${system} = {
      run-undercroft = pkg;
      default = pkg;
    };

    apps.${system}.default = {
      type = "app";
      program = "${pkgs.lib.getExe pkg}";
    };
  };
}
