{
  config,
  lib,
  pkgs,
  variables,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  upstreamPackage = inputs.serpantinum.packages.${system}.default;

  # ── Wallpaper ────────────────────────────────────────────────────────────
  assetDir = ../../../assets/wallpapers;
  wallpaperName =
    let
      candidates = [
        "${variables.wallpaper}.png"
        "${variables.wallpaper}.jpg"
        "${variables.wallpaper}.jpeg"
        "${variables.wallpaper}.webp"
      ];
      found = lib.findFirst (name: builtins.pathExists (assetDir + "/${name}")) null candidates;
    in
    if found == null then
      throw "variables.wallpaper = \"${variables.wallpaper}\" has no matching image in assets/wallpapers"
    else
      found;

  wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/${wallpaperName}";

  # ── Matugen templates ────────────────────────────────────────────────────
  # Every file here is copied into the Serpantinum package and driven by its
  # Matugen config, so a wallpaper change updates the whole desktop.
  hook = pkgs.writeShellScript "serpantinum-matugen-hook" ''
    set -u
    mode="''${1:-image}"

    hyprctl=${pkgs.hyprland}/bin/hyprctl
    jq=${pkgs.jq}/bin/jq
    pkill=${pkgs.procps}/bin/pkill
    timeout=${pkgs.coreutils}/bin/timeout

    # Re-read ~/.config/hypr/colors.lua in every running instance.
    if [ -d "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr" ] || [ -d /tmp/hypr ]; then
      for instance in $($hyprctl instances -j 2>/dev/null | $jq -r '.[].instance' 2>/dev/null); do
        $hyprctl -i "$instance" reload >/dev/null 2>&1 || true
      done
    fi

    # Kitty re-reads its config (including colors.conf) on SIGUSR1.
    $pkill -SIGUSR1 -f '.kitty-wrapped' 2>/dev/null || $pkill -SIGUSR1 kitty 2>/dev/null || true

    # Live-retheme Firefox / LibreWolf through the Pywalfox add-on. Only talk
    # to it when the extension is actually connected: `pywalfox update` would
    # otherwise start a daemon and block the Matugen hook.
    if [ "$mode" = "image" ] && [ -S "/tmp/pywalfox_socket_$(id -u)" ]; then
      $timeout 5 ${pkgs.pywalfox-native}/bin/pywalfox update >/dev/null 2>&1 || true
    fi
  '';

  imageTemplates = ''
    [templates.gtk3]
    input_path = "templates/gtk3.css.template"
    output_path = "~/.config/gtk-3.0/gtk.css"

    [templates.gtk4]
    input_path = "templates/gtk4.css.template"
    output_path = "~/.config/gtk-4.0/gtk.css"

    [templates.hyprland]
    input_path = "templates/hyprland.lua.template"
    output_path = "~/.config/hypr/colors.lua"

    [templates.neovim]
    input_path = "templates/nvim.lua.template"
    output_path = "~/.config/nvim/lua/matugen.lua"

    [templates.btop]
    input_path = "templates/btop.theme.template"
    output_path = "~/.config/btop/themes/matugen.theme"

    [templates.pywalfox]
    input_path = "templates/pywalfox.json.template"
    output_path = "~/.cache/wal/colors.json"
    index = 100
    post_hook = "${hook} image"
  '';

  # Static presets have no source image, so skip {{image}}-based templates.
  staticTemplates = ''
    [templates.gtk3]
    input_path = "templates/gtk3.css.template"
    output_path = "~/.config/gtk-3.0/gtk.css"

    [templates.gtk4]
    input_path = "templates/gtk4.css.template"
    output_path = "~/.config/gtk-4.0/gtk.css"

    [templates.hyprland]
    input_path = "templates/hyprland.lua.template"
    output_path = "~/.config/hypr/colors.lua"

    [templates.neovim]
    input_path = "templates/nvim.lua.template"
    output_path = "~/.config/nvim/lua/matugen.lua"

    [templates.btop]
    input_path = "templates/btop.theme.template"
    output_path = "~/.config/btop/themes/matugen.theme"
    index = 100
    post_hook = "${hook} static"
  '';

  serpantinum = upstreamPackage.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      matugen_dir="$out/share/serpantinum/assets/matugen"
      install -d "$matugen_dir/templates"

      cp -r ${./templates}/. "$matugen_dir/templates/"

      cat >> "$matugen_dir/config.toml" <<'MATUGEN_IMAGE_TEMPLATES'

      ${imageTemplates}
      MATUGEN_IMAGE_TEMPLATES

      cat >> "$matugen_dir/config-static.toml" <<'MATUGEN_STATIC_TEMPLATES'

      ${staticTemplates}
      MATUGEN_STATIC_TEMPLATES
    '';
  });

  # ── Settings ─────────────────────────────────────────────────────────────
  upstreamSettings = builtins.fromJSON (
    builtins.readFile "${inputs.serpantinum}/config/serpantinum/settings.json"
  );

  # Serpantinum applies the wallpaper on login, so a fresh machine starts with
  # the wallpaper named in variables.nix instead of an empty background. It
  # also regenerates the Matugen palette and runs the hook above.
  wallpaperService = pkgs.writeShellScript "serpantinum-wallpaper" ''
    set -u

    cli=${serpantinum}/bin/serpantinum
    wallpaper=${lib.escapeShellArg wallpaperPath}
    seq=${pkgs.coreutils}/bin/seq
    sleep=${pkgs.coreutils}/bin/sleep

    # Wait for the systemd-managed daemon, never start a second one.
    for _ in $($seq 1 100); do
      if [ -s /tmp/serpantinumd.pid ] && read -r pid < /tmp/serpantinumd.pid && kill -0 "$pid" 2>/dev/null; then
        break
      fi
      $sleep 0.1
    done

    # The shell's IPC endpoint can take a moment longer than the daemon.
    for _ in $($seq 1 50); do
      if "$cli" set wallpaper "$wallpaper" all >/dev/null 2>&1; then
        exit 0
      fi
      $sleep 0.2
    done

    exit 0
  '';

  settings = {
    general = {
      language = "en";
    };

    # The shell reads this top-level key, not general.wallpaperDir.
    wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";

    theme = {
      fontFamily = variables.fonts.ui;
      borderRadius = 12;
      activePreset = "Matugen";
      matugen = true;
      mode = variables.colorMode;
      schemeType = variables.schemeType;
    };

    bar = {
      position = "top";
      height = 42;
      autohide = false;
      time.format = "HH:mm";
    };

    notifications = {
      dnd = false;
      position = "top right";
      sound = true;
    };

    idle = {
      enabled = true;
      actions = {
        dim.timeout = 180;
        dpms.timeout = 300;
        lock.timeout = 420;
        suspend.timeout = 900;
      };
    };

    dock = {
      enabled = true;
      position = "bottom";
      autohide = true;
      smartAutohide = true;
    };
  };

  # Serpantinum's Home Manager module merges its bundled settings.json with
  # `settings` and only writes the result when settings.json does not exist
  # yet. Regenerate the same merged file ourselves and install it on every
  # activation, so declarative changes also reach machines that already booted
  # the shell once.
  mergedSettings = lib.recursiveUpdate upstreamSettings (
    lib.filterAttrsRecursive (_: value: value != null) settings
  );
  settingsFile = (pkgs.formats.json { }).generate "serpantinum-settings.json" mergedSettings;
in
{
  imports = [ inputs.serpantinum.homeManagerModules.default ];

  programs.serpantinum = {
    enable = true;
    package = serpantinum;
    systemd.enable = true;
    inherit settings;
  };

  home.activation.serpantinumDeclarativeSettings =
    lib.hm.dag.entryAfter
      [
        "writeBoundary"
        "serpantinumSettings"
      ]
      ''
        run mkdir -p "${config.xdg.configHome}/serpantinum"
        run install -m 0644 ${settingsFile} "${config.xdg.configHome}/serpantinum/settings.json"
      '';

  # Skip Serpantinum's first-launch wallpaper wizard: this config is declarative.
  home.activation.serpantinumSkipFirstLaunch = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.xdg.stateHome}/serpantinum"
    run touch "${config.xdg.stateHome}/serpantinum/first_launch.done"
  '';

  # Apply variables.wallpaper on every login. This is deliberately idempotent:
  # editing the wallpaper in variables.nix updates the desktop after the next
  # switch, and a wallpaper picked at runtime is restored to the declarative
  # one on the next login.
  systemd.user.services.serpantinum-wallpaper = lib.mkIf config.programs.serpantinum.systemd.enable {
    Unit = {
      Description = "Apply the declarative Serpantinum wallpaper";
      After = [ "serpantinum.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = wallpaperService;
      RemainAfterExit = true;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
