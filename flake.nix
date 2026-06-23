{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = { self, nixpkgs, rust-overlay, utils, naersk, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        naersk' = pkgs.callPackage naersk { };
        libs = with pkgs; [
          libGL
          libx11
          libxcursor
          libxkbcommon
          libxi
          libxrandr
          sdl3.dev
          wayland
        ];
        libPath = with pkgs;
          lib.makeLibraryPath libs;
          binName = "sdl-sandbox";
      in {
        defaultPackage = naersk'.buildPackage {
          src = ./.;
          pname = binName;
          nativebuildInputs = [ pkgs.makeWrapper ];
          postFixUp = ''
            wrapProgram "$out/bin/${binName}" --set LD_LIBRARY_PATH "${libPath}"
          '';
        };
        defaultApp = utils.lib.mkApp { drv = self.defaultPackage."${system}"; };
        devShell = with pkgs; mkShell {
          buildInputs = [
            (rust-bin.stable.latest.default.override {
              extensions = ["clippy"];
            })
          ] ++ libs;

          LD_LIBRARY_PATH = libPath;
        };
      });
}