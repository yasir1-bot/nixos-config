{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  networking = {
    hostName = variables.hostname;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  # NetworkManager handles Wi-Fi. Do not set networking.wireless.enable
  # yourself: the NetworkManager module owns that option in current nixpkgs.

  # mDNS / network printers.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.resolved.enable = true;

  # A sane default time source.
  services.chrony.enable = true;
}
