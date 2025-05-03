{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { ... }@inputs:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";

      foxFlssDerivation =
        {
          autoPatchelfHook,
          autoreconfHook,
          stdenv,
          src,
        }:
        stdenv.mkDerivation {
          name = "fox-flss";
          nativeBuildInputs = [
            autoreconfHook
            autoPatchelfHook
          ];
          inherit src;
        };
      foxFlss = pkgs.callPackage foxFlssDerivation { src = ./Application; };
    in
    {
      packages.${system}.default = foxFlss;
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.automake
          pkgs.autoconf
          pkgs.gcc
        ];
      };
    };
}
