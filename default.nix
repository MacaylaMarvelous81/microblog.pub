{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs {},
}:
pkgs.python3.pkgs.callPackage ./build.nix {}
