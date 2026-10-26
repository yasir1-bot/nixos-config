{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.serpantinum.nixosModules.default ];

  programs.serpantinum.enable = true;

  # Serpantinum's lock screen has its own PAM service.
  security.pam.services.serpantinum = { };

  # Handy for regenerating a palette from a terminal:
  #   matugen image ~/Pictures/Wallpapers/black-hole.png -c \
  #     $(nix eval --raw .#nixosConfigurations.${variables.hostname}.config.programs.serpantinum.package)/share/serpantinum/assets/matugen/config.toml
  environment.systemPackages = [ pkgs.matugen ];
}
