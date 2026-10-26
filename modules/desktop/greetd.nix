{
  config,
  lib,
  pkgs,
  ...
}:
let
  sessionsDir = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings = {
      default_session = {
        user = "greeter";
        command = lib.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-user-session"
          "--sessions ${sessionsDir}"
          "--default-session hyprland-uwsm"
        ];
      };
    };
  };

  # The greetd module already creates /var/cache/tuigreet for tuigreet's
  # --remember state, so no tmpfiles rule is needed here.

  # Belt and braces: don't fight greetd for VT1.
  systemd.services."getty@tty1".enable = false;
}
