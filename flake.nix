{
  description = "Adrenaline — NixOS + Hyprland + Serpantinum, fully declarative";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    serpantinum = {
      url = "github:ilyamiro/serpantinum";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Every file under ./flake is a top-level flake-parts module. The NixOS and
  # Home Manager modules stay under ./modules and are imported by the host, so
  # import-tree never mistakes them for flake-parts modules.
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree ./flake
    );
}
