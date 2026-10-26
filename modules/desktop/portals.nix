{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    # The Hyprland module adds xdg-desktop-portal-hyprland itself; GTK is the
    # sane fallback for file pickers, notifications, and Flatpak apps.
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };
}
