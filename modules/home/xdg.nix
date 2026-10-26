{
  config,
  variables,
  ...
}:
let
  browserDesktop = if variables.browser == "firefox" then "firefox.desktop" else "librewolf.desktop";
in
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      # Export XDG_* variables for the configured user directories.
      setSessionVariables = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = browserDesktop;
        "x-scheme-handler/http" = browserDesktop;
        "x-scheme-handler/https" = browserDesktop;
        "x-scheme-handler/about" = browserDesktop;
        "x-scheme-handler/unknown" = browserDesktop;

        "inode/directory" = "org.gnome.Nautilus.desktop";

        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/webp" = "imv.desktop";

        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";

        "application/pdf" = "org.pwmt.zathura.desktop";

        "text/plain" = "codium.desktop";
        "application/json" = "codium.desktop";
        "application/x-shellscript" = "codium.desktop";
      };
    };
  };

  home.sessionVariables.BROWSER = if variables.browser == "firefox" then "firefox" else "librewolf";
}
