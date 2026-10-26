hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Prefer hardware cursors off on hybrid GPUs; harmless on single-GPU boxes.
hl.env("XCURSOR_THEME", _G.cursorTheme or "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", tostring(_G.cursorSize or 24))
hl.env("HYPRCURSOR_THEME", _G.cursorTheme or "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", tostring(_G.cursorSize or 24))
