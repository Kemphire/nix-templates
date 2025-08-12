{
  description = "nix templates for my day-to-day programming languages";

  outputs = {self}: {
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
      rust = {
        path = ./rust-template;
        description = "Rust development environment nix flake";
        welcomeText = ''
          # Welcome **rustaceans**
        '';
      };
    };
  };
}
