hl.config({
  general = {
    border_size = _G.borderSize or 2,
    gaps_in = _G.gapsIn or 5,
    gaps_out = _G.gapsOut or 10,
    float_gaps = 8,
    resize_on_border = true,
    extend_border_grab_area = 24,

    -- Fallbacks; the Matugen palette in colors.lua overrides these.
    col = {
      active_border = {
        colors = { "rgba(00e5ffff)", "rgba(ff2d95ff)" },
        angle = 45,
      },
      inactive_border = "rgba(ffffff1a)",
    },
  },

  decoration = {
    rounding = 12,
    active_opacity = 1.0,
    inactive_opacity = 0.97,

    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      new_optimizations = true,
      xray = true,
    },

    shadow = {
      enabled = true,
      range = 18,
      render_power = 3,
      color = "rgba(00000055)",
    },
  },

  input = {
    kb_layout = _G.kbLayout or "gb",
    kb_variant = _G.kbVariant or "",
    follow_mouse = 1,
    sensitivity = 0,
    accel_profile = "flat",

    touchpad = {
      natural_scroll = true,
      disable_while_typing = false,
      tap_to_click = true,
    },
  },

  cursor = {
    -- 0 = hardware cursors when possible, 1 = always software, 2 = auto.
    no_hardware_cursors = 1,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  misc = {
    focus_on_activate = false,
    font_family = _G.monoFont or "JetBrainsMono Nerd Font",
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },
})

-- ── Animations ─────────────────────────────────────────────────────────────
hl.curve("adrenaline", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("snap", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 4.5, bezier = "adrenaline", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.0, bezier = "adrenaline", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "adrenaline", style = "slide" })
hl.animation({ leaf = "layers", enabled = true, speed = 4.0, bezier = "snap", style = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.0, bezier = "snap", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3.5, bezier = "snap", style = "fade" })
hl.animation({ leaf = "fade", enabled = true, speed = 4.0, bezier = "snap" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4.0, bezier = "snap" })
hl.animation({ leaf = "border", enabled = true, speed = 4.0, bezier = "snap" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, bezier = "adrenaline", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 4.0, bezier = "snap", style = "fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3.5, bezier = "snap", style = "fade" })

-- Three-finger horizontal swipe switches workspaces.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
