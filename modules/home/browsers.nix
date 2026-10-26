{
  lib,
  pkgs,
  variables,
  ...
}:
let
  useLibreWolf = variables.browser == "librewolf" || variables.browser == "both";
  useFirefox = variables.browser == "firefox" || variables.browser == "both";

  # Both browsers read the palette Matugen writes to ~/.cache/wal/colors.json.
  # The Pywalfox add-on talks to this native host.
  pywalfoxManifest = pkgs.writeText "pywalfox-native-host.json" (
    builtins.toJSON {
      name = "pywalfox";
      description = "Pywalfox native messaging host";
      path = "${pkgs.pywalfox-native}/bin/pywalfox";
      type = "stdio";
      allowed_extensions = [ "pywalfox@frewacom.org" ];
    }
  );

  settings = {
    # Wayland / portal integration.
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.settings" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;

    # Hardware video decoding (VA-API).
    "media.ffmpeg.vaapi.enable" = true;

    # Keep the UI dark; Pywalfox overrides the actual colours.
    "ui.systemUsesDarkTheme" = if variables.colorMode == "dark" then 1 else 0;
    "layout.css.prefers-color-scheme.content-override" = if variables.colorMode == "dark" then 0 else 1;

    # Tabs.
    "browser.tabs.loadInBackground" = true;
    "browser.tabs.warnOnClose" = false;
    "browser.compactmode.show" = true;
  };
in
{
  home.packages = [ pkgs.pywalfox-native ];

  programs.librewolf = lib.mkIf useLibreWolf {
    enable = true;
    package = pkgs.librewolf;

    profiles.default = {
      id = 0;
      name = "default";
      settings = settings;
    };
  };

  # LibreWolf looks in ~/.librewolf/native-messaging-hosts.
  home.file.".librewolf/native-messaging-hosts/pywalfox.json" = lib.mkIf useLibreWolf {
    source = pywalfoxManifest;
  };

  programs.firefox = lib.mkIf useFirefox {
    enable = true;
    package = pkgs.firefox;

    profiles.default = {
      id = 0;
      name = "default";
      settings = settings;
    };
  };

  # Firefox looks in ~/.mozilla/native-messaging-hosts.
  home.file.".mozilla/native-messaging-hosts/pywalfox.json" = lib.mkIf useFirefox {
    source = pywalfoxManifest;
  };
}
