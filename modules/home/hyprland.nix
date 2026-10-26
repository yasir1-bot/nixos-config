{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
let
  browser = if variables.browser == "firefox" then "firefox" else "librewolf";
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    # NixOS owns the compositor (so UWSM, portals and the session file come
    # from the system); Home Manager only writes the Lua configuration.
    package = null;
    portalPackage = null;

    configType = "lua";
    systemd.enable = true;
    xwayland.enable = true;

    extraLuaFiles = {
      # Globals consumed by the other Lua files. Keep this first: the
      # generated hyprland.lua requires files in alphabetical order.
      "00-variables" = ''
        mainMod = "${variables.hyprland.mainMod}"
        terminal = "${variables.terminal}"
        fileManager = "${variables.fileManager}"
        browser = "${browser}"
        kbLayout = "${variables.keyboardLayout}"
        kbVariant = "${variables.keyboardVariant}"
        monitorScale = ${toString variables.hyprland.monitorScale}
        gapsIn = ${toString variables.hyprland.gapsIn}
        gapsOut = ${toString variables.hyprland.gapsOut}
        borderSize = ${toString variables.hyprland.borderSize}
        uiFont = "${variables.fonts.ui}"
        monoFont = "${variables.fonts.mono}"
        cursorTheme = "${variables.cursor.name}"
        cursorSize = ${toString variables.cursor.size}
      '';

      "10-env" = ./hyprland/env.lua;
      "15-monitors" = ./hyprland/monitors.lua;
      "20-settings" = ./hyprland/settings.lua;
      "30-keybinds" = ./hyprland/keybinds.lua;
      "40-rules" = ./hyprland/rules.lua;
    };

    # Matugen rewrites ~/.config/hypr/colors.lua whenever the wallpaper
    # changes. Re-apply it here so a config reload picks the new palette up.
    extraConfig = ''
      -- ── Matugen palette ──────────────────────────────────────────────────
      package.loaded["colors"] = nil
      local ok, colors = pcall(require, "colors")

      if ok and type(colors) == "table" then
        hl.config({
          general = {
            col = {
              active_border = colors.active_border,
              inactive_border = colors.inactive_border,
            },
          },
          decoration = {
            shadow = {
              color = colors.shadow,
            },
          },
          misc = {
            background_color = colors.background,
          },
        })
      end
    '';
  };
}
