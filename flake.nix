{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {self, ...}: {
    templates = {
      go = {
        path = ./go-template;
        description = "A starter go template";
      };
      welcomText = ''
        You successfully created your go template
      '';
    };
  };
}
