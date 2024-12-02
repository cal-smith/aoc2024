{
  description = "cal-smith's aoc2024";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    let
      nixpkgsConfig = {
        config.allowUnfree = true;
      };
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      legacyPackage.aarch64-darwin.default = pkgs;
      devShells.aarch64-darwin = pkgs.callPackage ./shells.nix { };
      packages.aarch64-darwin.activate-ruby = pkgs.writeShellScriptBin "activate-ruby-nix" ''
        echo "export GEM_HOME=\"$GEM_HOME\""
        echo "export GEM_PATH=\"$GEM_PATH\""
        echo "export BUNDLE_PATH=\"$GEM_HOME\""
        echo "export PATH=\"$(command -v ruby | xargs dirname):$GEM_HOME/bin:\$PATH\""
      '';
    };
}