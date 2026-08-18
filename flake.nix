{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    forEachSystem = platforms: function:
      nixpkgs.lib.genAttrs
        platforms
        (system: function system (import nixpkgs { inherit system; }));
  in
  {
    overlays.default = self.overlays.harkvim;
    overlays.harkvim = final: prev: {
      harkvim = prev.callPackage ./default.nix { };
    };
    overlays.nvim = final: prev: {
      nvim = prev.callPackage ./default.nix { };
    };

    packages = forEachSystem
      nixpkgs.lib.platforms.unix
      (system: pkgs: {
        default = self.packages.${system}.harkvim;
        harkvim = pkgs.callPackage ./default.nix { };
      });

    devShells = forEachSystem
      (nixpkgs.lib.platforms.linux ++ nixpkgs.lib.platforms.darwin)
      (_: pkgs: {
        default = import ./shell.nix { inherit pkgs; };
      });
  };
}
