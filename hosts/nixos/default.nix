{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core/boot.nix
    ../../modules/core/nix.nix
    ../../modules/core/locale.nix
    ../../modules/core/networking.nix
    ../../modules/core/users.nix
    ../../modules/core/packages.nix
    ../../modules/core/security.nix

    ../../modules/hardware/graphics.nix
    ../../modules/hardware/system.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/portals.nix
    ../../modules/desktop/serpantinum.nix
  ];

  system.stateVersion = variables.stateVersion;
}
