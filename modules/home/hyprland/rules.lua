-- Keep XWayland drags from fighting the compositor.
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Floating utility windows.
hl.window_rule({
  name = "float-utilities",
  match = {
    class = "^(pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Calculator|file-roller)$",
  },
  float = true,
  size = "900 620",
  center = true,
})

hl.window_rule({
  name = "float-file-pickers",
  match = { title = "^(Open File|Save File|Open Folder|Choose File)$" },
  float = true,
  size = "900 620",
  center = true,
})
