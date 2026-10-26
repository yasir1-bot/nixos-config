# ┌──────────────────────────────────────────────────────────────────────────┐
# │  variables.nix — the only file you normally need to edit.                │
# │                                                                          │
# │  Everything here is consumed by the modules in ./modules. Random         │
# │  packages you want to add go at the bottom under `extraPackages` /       │
# │  `extraHomePackages`.                                                    │
# └──────────────────────────────────────────────────────────────────────────┘
{
  # ── Identity ─────────────────────────────────────────────────────────────
  name = "Yasir";
  username = "yasir";
  email = "yasir@example.com";
  hostname = "nixos";

  # Used only to create the account on first boot. Change it with `passwd`
  # immediately after logging in.
  initialPassword = "nixos";

  # Where this flake lives on the target machine. Only used by the shell
  # aliases (`rebuild`, `update`); change it if you clone elsewhere.
  flakeDir = "/etc/nixos";

  # Bump this when you move to a newer NixOS release.
  stateVersion = "25.11";

  # ── Locale ───────────────────────────────────────────────────────────────
  timeZone = "Europe/London";
  locale = "en_GB.UTF-8";
  keyboardLayout = "gb";
  keyboardVariant = "";

  # ── Bootloader ───────────────────────────────────────────────────────────
  # "systemd-boot" | "grub-efi" | "grub-bios"
  bootloader = "systemd-boot";

  # Only read when bootloader = "grub-bios".
  bootDevice = "/dev/nvme0n1";

  # "default" | "zen" | "latest"
  kernel = "zen";

  # "amd" | "intel" — enables the matching microcode updates.
  cpuVendor = "amd";

  # ── GPU ──────────────────────────────────────────────────────────────────
  # "amd" | "intel" | "nvidia" | "vm"
  gpu = "amd";

  # Only used for `gpu = "nvidia"`. Open modules need a Turing (GTX 16xx /
  # RTX 20xx) or newer card; set to false for older hardware.
  nvidiaOpen = true;

  # ── Desktop ──────────────────────────────────────────────────────────────
  hyprland = {
    mainMod = "SUPER";
    borderSize = 2;
    gapsIn = 5;
    gapsOut = 10;
    monitorScale = 1.0;
  };

  terminal = "kitty";
  fileManager = "nautilus";

  # "librewolf" | "firefox" | "both"
  browser = "librewolf";

  # Filename (without extension) of a wallpaper in ./assets/wallpapers.
  # Matugen derives the whole desktop palette from it.
  wallpaper = "black-hole";

  # Any Matugen scheme: scheme-tonal-spot, scheme-content, scheme-expressive,
  # scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral,
  # scheme-rainbow, scheme-vibrant
  schemeType = "scheme-tonal-spot";
  colorMode = "dark";

  fonts = {
    ui = "Inter";
    mono = "JetBrainsMono Nerd Font";
  };

  cursor = {
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # ── Features ─────────────────────────────────────────────────────────────
  flatpak = true;
  gaming = false;

  ssh = {
    enable = false;
    # authorized_keys entries for the normal user
    keys = [ ];
  };

  # Extra *system* packages. Names are looked up in nixpkgs, so dotted
  # attribute paths work too (e.g. "nerd-fonts.iosevka").
  extraPackages = [ ];

  # Extra *home* packages (user profile). Same naming rules.
  extraHomePackages = [ ];

  # Nix garbage collection.
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
