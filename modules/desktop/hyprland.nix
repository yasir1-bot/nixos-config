{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";

    XCURSOR_THEME = variables.cursor.name;
    XCURSOR_SIZE = toString variables.cursor.size;
    HYPRCURSOR_THEME = variables.cursor.name;
    HYPRCURSOR_SIZE = toString variables.cursor.size;
  };
}
