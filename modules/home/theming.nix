{
  pkgs,
  variables,
  ...
}:
{
  # ── Cursor ───────────────────────────────────────────────────────────────
  home.pointerCursor = {
    enable = true;
    name = variables.cursor.name;
    package = pkgs.bibata-cursors;
    size = variables.cursor.size;
    gtk.enable = true;
    x11.enable = true;
  };

  # ── GTK ──────────────────────────────────────────────────────────────────
  # Matugen owns ~/.config/gtk-3.0/gtk.css and ~/.config/gtk-4.0/gtk.css.
  # Keep `gtk.theme` and `gtk4.theme` at null, and never set `extraCss`, or
  # Home Manager will generate those files and fight Matugen for them.
  gtk = {
    enable = true;

    font = {
      name = variables.fonts.ui;
      size = 11;
    };

    theme = null;
    gtk3.theme = null;
    gtk4.theme = null;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = variables.colorMode == "dark";
    gtk4.extraConfig.gtk-application-prefer-dark-theme = variables.colorMode == "dark";
  };

  # ── Qt ───────────────────────────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  # ── GNOME/GTK app defaults ───────────────────────────────────────────────
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = if variables.colorMode == "dark" then "prefer-dark" else "default";
    font-name = "${variables.fonts.ui} 11";
    monospace-font-name = "${variables.fonts.mono} 10";
    cursor-theme = variables.cursor.name;
    cursor-size = variables.cursor.size;
  };
}
