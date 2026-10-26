{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;

    # Serpantinum's own lock screen uses this PAM service (created by the
    # Serpantinum NixOS module, kept here for clarity).
    pam.services.serpantinum = { };

    # Unlock the login keyring together with the session.
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.openssh = lib.mkIf variables.ssh.enable {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    openFirewall = true;
  };

  # Kernel auditing.
  security.auditd.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
