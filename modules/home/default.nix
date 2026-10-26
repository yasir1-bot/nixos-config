{
  variables,
  ...
}:
{
  # The Home Manager release this configuration was written for. Keep it at
  # the release you originally installed, even after upgrading NixOS.
  home.stateVersion = variables.stateVersion;

  imports = [
    ./packages.nix
    ./theming.nix
    ./kitty.nix
    ./shell.nix
    ./git.nix
    ./browsers.nix
    ./wallpapers.nix
    ./neovim.nix
    ./xdg.nix
    ./hyprland.nix
    ./serpantinum/default.nix
  ];
}
