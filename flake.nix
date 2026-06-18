# SPDX-License-Identifier: MPL-2.0
{
  description = "kategoria — dependently-typed proof routes and demos in Idris 2";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          # Idris 2 (with its Chez backend) + the just task runner.
          packages = [ pkgs.idris2 pkgs.just ];
        };
      });
    };
}
