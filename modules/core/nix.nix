{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "@wheel"
    ];
    warn-dirty = false;
    connect-timeout = 5;
    download-attempts = 5;
  };

  nix.gc = {
    inherit (variables.gc) automatic dates options;
  };

  nixpkgs.config.allowUnfree = true;

  # Run prebuilt binaries (AppImages, language servers, vendor tools).
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    zstd
    openssl
    curl
    icu
    libxml2
    libGL
    glib
    libxkbcommon
    wayland
  ];

  # Keep documentation and `nixos-rebuild` fast.
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = false;
    nixos.enable = true;
  };
}
