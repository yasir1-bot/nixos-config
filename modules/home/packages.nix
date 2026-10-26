{
  lib,
  pkgs,
  variables,
  ...
}:
let
  resolve = name: lib.getAttrFromPath (lib.splitString "." name) pkgs;

  # The apps you asked for. Everything here is in nixpkgs-unstable and
  # currently builds on x86_64-linux.
  desktopApps = with pkgs; [
    anki
    bitwarden-desktop
    obsidian
    prismlauncher
    vscodium
    zathura
  ];
in
{
  home.packages =
    desktopApps
    ++ (map resolve variables.extraHomePackages)
    ++ lib.optionals variables.gaming (
      with pkgs;
      [
        lutris
        mangohud
      ]
    );
}
