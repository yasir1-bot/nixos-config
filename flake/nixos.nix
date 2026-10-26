{
  inputs,
  ...
}:
let
  variables = import ../variables.nix;
in
{
  flake.nixosConfigurations.${variables.hostname} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs variables; };

    modules = [
      ../hosts/nixos

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = { inherit inputs variables; };

        home-manager.users.${variables.username} = import ../modules/home;
      }
    ];
  };
}
