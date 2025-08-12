{
  description = "A rust nix dev environment flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        rust-analyzer
        clippy
        cargo
        rustc
        rustfmt
      ];
      nativeBuildInputs = [pkgs.pkg-config];
      # env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustcSrc}";
      RUST_BACKTRACE = 1;
    };
  };
}
