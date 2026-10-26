# ┌──────────────────────────────────────────────────────────────────────────┐
# │  PLACEHOLDER — REPLACE THIS FILE                                          │
# │                                                                          │
# │  On the target machine, after installing NixOS (or when booted from the   │
# │  installer), run:                                                         │
# │                                                                          │
# │      sudo nixos-generate-config --root /mnt                               │
# │      sudo cp /mnt/etc/nixos/hardware-configuration.nix \                  │
# │        /etc/nixos/my-nixos-config/hosts/nixos/hardware-configuration.nix  │
# │                                                                          │
# │  or copy the generated file into this repository from wherever you keep   │
# │  it and rebuild. The values below are a reasonable starting point for a   │
# │  single-disk UEFI install with labels `nixos` and `BOOT`, but the UUIDs    │
# │  almost certainly will not match your machine.                           │
# └──────────────────────────────────────────────────────────────────────────┘
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
