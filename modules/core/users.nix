{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  users.mutableUsers = true;

  users.users.${variables.username} = {
    isNormalUser = true;
    description = variables.name;
    initialPassword = variables.initialPassword;
    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "uinput"
      "render"
      "lp"
      "scanner"
      "plugdev"
    ];

    openssh.authorizedKeys.keys = variables.ssh.keys;
  };

  # zsh must be registered as a valid login shell.
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
}
