{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
let
  kernelPackages =
    {
      default = pkgs.linuxPackages;
      zen = pkgs.linuxPackages_zen;
      latest = pkgs.linuxPackages_latest;
    }
    .${variables.kernel} or (throw "variables.kernel must be one of: default, zen, latest");

  isGrub = variables.bootloader != "systemd-boot";
  isGrubBios = variables.bootloader == "grub-bios";
in
{
  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = !isGrubBios;

    systemd-boot.enable = variables.bootloader == "systemd-boot";

    grub = lib.mkIf isGrub {
      enable = true;
      device = if isGrubBios then variables.bootDevice else "nodev";
      efiSupport = variables.bootloader == "grub-efi";
      efiInstallAsRemovable = false;
      useOSProber = false;
    };
  };

  boot.kernelPackages = kernelPackages;
  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
    "nowatchdog"
  ];

  boot.tmp.cleanOnBoot = true;

  # CPU microcode
  hardware.cpu.amd.updateMicrocode = variables.cpuVendor == "amd";
  hardware.cpu.intel.updateMicrocode = variables.cpuVendor == "intel";

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.sysrq" = 1;
  };
}
