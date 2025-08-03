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
        welcomeText = ''
          # You successfully created your go template
        '';
      };
      flutter = {
        path = ./flutter-template;
        description = "A painless flutter template";
        welcomeText = ''
          # you successfully create your flutter template
        '';
      };
    };
  };
}
