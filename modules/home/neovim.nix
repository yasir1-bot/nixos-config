{
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = false;

    # Keep Home Manager out of ~/.config/nvim/init.lua; the files below are
    # managed individually so Matugen can write lua/matugen.lua next to them.
    initLua = "";
  };

  xdg.configFile = {
    "nvim/init.lua".source = ./nvim/init.lua;
    "nvim/lua/config/options.lua".source = ./nvim/lua/config/options.lua;
    "nvim/lua/config/keymaps.lua".source = ./nvim/lua/config/keymaps.lua;
    "nvim/lua/config/theme.lua".source = ./nvim/lua/config/theme.lua;
  };
}
