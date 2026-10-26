{
  config,
  lib,
  variables,
  ...
}:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Keep the legacy home-directory dotfiles layout explicitly.
    dotDir = config.home.homeDirectory;

    defaultKeymap = "emacs";

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      expireDuplicatesFirst = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      MANPAGER = "less -R";
      LESS = "-R";
    };

    shellAliases = {
      ls = "eza --icons=auto --group-directories-first";
      ll = "eza -lah --icons=auto --group-directories-first --git";
      la = "eza -lah --icons=auto --group-directories-first";
      lt = "eza --tree --level=2 --icons=auto";
      cat = "bat --style=plain";
      grep = "grep --color=auto";
      df = "duf";
      rebuild = "sudo nixos-rebuild switch --flake ${variables.flakeDir}#${variables.hostname}";
      boot = "sudo nixos-rebuild boot --flake ${variables.flakeDir}#${variables.hostname}";
      update = "sudo nix flake update --flake ${variables.flakeDir}";
      gc = "sudo nix-collect-garbage --delete-older-than 14d";
    };

    initContent = ''
      setopt AUTO_CD
      setopt NO_BEEP

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      bindkey -e
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line

      if [[ -o login ]]; then
        fastfetch
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 1000;

      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "bold magenta";
        format = " [$branch]($style)";
      };

      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style))";
      };

      nix_shell = {
        style = "bold blue";
        format = " [nix:$name]($style)";
        disabled = false;
      };

      cmd_duration = {
        min_time = 2000;
        format = " [$duration]($style)";
        style = "bold yellow";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold yellow)";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      bg = "-1";
      "bg+" = "-1";
      fg = "-1";
      hl = "cyan";
      "fg+" = "-1";
      "hl+" = "cyan";
      info = "yellow";
      prompt = "green";
      pointer = "magenta";
      marker = "yellow";
      spinner = "cyan";
      header = "blue";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # Matugen writes ~/.config/btop/themes/matugen.theme; this only points
  # btop at it. Do not let Home Manager own the theme file itself.
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "matugen";
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_gradient = false;
      mem_graphs = true;
      show_swap = true;
      swap_disk = false;
    };
  };
}
