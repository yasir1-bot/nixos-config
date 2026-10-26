{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
let
  locale = variables.locale;
in
{
  time.timeZone = variables.timeZone;

  i18n = {
    defaultLocale = locale;

    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };

  console.keyMap = variables.keyboardLayout;

  services.xserver.xkb = {
    layout = variables.keyboardLayout;
    variant = variables.keyboardVariant;
  };

  # Keyboard layout switches with Alt+Shift, like a typical GB setup.
  services.xserver.xkb.options = lib.mkIf (variables.keyboardVariant != "") "grp:alt_shift_toggle";
}
