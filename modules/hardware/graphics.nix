{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = variables.gaming;
  };

  # ── GPU specific setup ───────────────────────────────────────────────────
  boot.initrd.kernelModules = lib.optionals (variables.gpu == "amd") [ "amdgpu" ];
  services.xserver.videoDrivers = lib.optionals (variables.gpu == "nvidia") [ "nvidia" ];

  hardware.graphics.extraPackages =
    lib.optionals (variables.gpu == "amd") (
      with pkgs;
      [
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
      ]
    )
    ++ lib.optionals (variables.gpu == "intel") (
      with pkgs;
      [
        intel-media-driver
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
        vpl-gpu-rt
      ]
    )
    ++ lib.optionals (variables.gpu == "vm") (
      with pkgs;
      [
        mesa
        vulkan-loader
      ]
    );

  hardware.nvidia = lib.mkIf (variables.gpu == "nvidia") {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = variables.nvidiaOpen;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
