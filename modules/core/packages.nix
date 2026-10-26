{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
let
  resolve = name: lib.getAttrFromPath (lib.splitString "." name) pkgs;

  cliTools = with pkgs; [
    bat
    btop
    curl
    duf
    eza
    fastfetch
    fd
    file
    fzf
    git
    htop
    inxi
    jq
    ncdu
    pciutils
    psmisc
    ripgrep
    rsync
    strace
    toybox
    tree
    unzip
    usbutils
    wget
    which
    yq-go
    zip
    zoxide
  ];

  waylandTools = with pkgs; [
    brightnessctl
    cliphist
    grim
    libnotify
    matugen
    pavucontrol
    playerctl
    satty
    slurp
    wf-recorder
    wl-clipboard
    wtype
  ];

  desktopApps = with pkgs; [
    blueman
    file-roller
    gnome-calculator
    imv
    kitty
    mpv
    nautilus
    networkmanagerapplet
    xdg-user-dirs
    xdg-utils
  ];

  devTools = with pkgs; [
    cargo
    cmake
    gcc
    gnumake
    go
    ninja
    nodejs
    pkg-config
    python3
    rustc
  ];
in
{
  environment.systemPackages =
    cliTools
    ++ waylandTools
    ++ desktopApps
    ++ devTools
    ++ (map resolve variables.extraPackages)
    ++ lib.optional (variables.gaming) pkgs.mangohud
    ++ lib.optional (variables.gaming) pkgs.gamescope;

  fonts.packages = with pkgs; [
    inter
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.enable = true;

  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam = lib.mkIf variables.gaming {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  programs.gamemode.enable = variables.gaming;

  services.flatpak.enable = variables.flatpak;

  # AppImages and other prebuilt binaries.
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
