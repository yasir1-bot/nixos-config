{
  config,
  pkgs,
  variables,
  ...
}:
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    font = {
      name = variables.fonts.mono;
      size = 9;
    };

    settings = {
      # Window
      window_padding_width = 15;
      hide_window_decorations = true;
      confirm_os_window_close = 0;

      # Aesthetics
      cursor_shape = "block";
      cursor_blink_interval = 0;
      enable_audio_bell = false;

      # Powerline tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Remote control (used by scripts, e.g. setting the window title).
      allow_remote_control = true;
      listen_on = "unix:\${XDG_RUNTIME_DIR}/kitty-{kitty_pid}";
    };

    keybindings = {
      "ctrl+insert" = "copy_to_clipboard";
      "shift+insert" = "paste_from_clipboard";

      # Send Shift+Enter as CSI-u so TUIs can tell it apart from Enter.
      "shift+enter" = "send_text all \\e[13;2u";

      # Kitty's legacy encoding sends Alt+Shift+Enter as Alt+Enter; use
      # CSI-u so tmux can match M-S-Enter.
      "alt+shift+enter" = "send_text all \\e[13;4u";
    };

    # Matugen rewrites this file whenever the wallpaper changes. The include
    # is last so the generated palette wins over the defaults above.
    extraConfig = ''
      include ${config.xdg.configHome}/kitty/colors.conf
    '';
  };
}
