{
  config,
  lib,
  pkgs,
  variables,
  ...
}:
{
  # ── Bluetooth ────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true;
      FastConnectable = true;
    };
  };

  hardware.i2c.enable = true;

  # ── Power / thermals ─────────────────────────────────────────────────────
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.thermald.enable = variables.cpuVendor == "intel";
  services.fwupd.enable = true;

  # ── Audio ────────────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;

    extraConfig.pipewire."99-adrenaline.conf" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [
          44100
          48000
          96000
        ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
  };

  security.rtkit.enable = true;

  services.pipewire.wireplumber.extraConfig."99-bluez" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
        "a2dp_sink"
        "a2dp_source"
      ];
    };
  };

  # ── Storage / printing ───────────────────────────────────────────────────
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  services.printing.enable = true;
  services.udisks2.enable = true;

  # ── Misc hardware ────────────────────────────────────────────────────────
  services.libinput.enable = true;
  services.fstrim.enable = true;
}
