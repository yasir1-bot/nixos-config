-- Applies the Matugen palette generated at ~/.config/nvim/lua/matugen.lua.
-- Matugen owns that file; Home Manager owns this one.

local M = {}

local fallback = {
  bg = "#101014",
  bg_alt = "#17171d",
  bg_highlight = "#1e1e27",
  base = "#0b0b0e",

  fg = "#e6e1e5",
  fg_dim = "#c9c4d0",
  comment = "#8b8693",
  line_nr = "#4a4650",

  primary = "#8ecdf7",
  secondary = "#c6bfff",
  tertiary = "#ffb4a9",

  error = "#ffb4ab",
  warning = "#ffb86c",
  info = "#8ecdf7",
  success = "#9edc9b",

  border = "#4a4650",
  selection = "#3c3a47",
  search = "#5c5470",
  match = "#7a6c8f",
}

local function palette()
  package.loaded["matugen"] = nil
  local ok, colors = pcall(require, "matugen")
  if ok and type(colors) == "table" then
    return colors
  end
  return fallback
end

local function apply()
  local p = palette()

  vim.o.background = "dark"

  local groups = {
    Normal = { fg = p.fg, bg = p.bg },
    NormalNC = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.bg_alt },
    FloatBorder = { fg = p.border, bg = p.bg_alt },
    FloatTitle = { fg = p.primary, bg = p.bg_alt, bold = true },

    Cursor = { fg = p.base, bg = p.primary },
    CursorLine = { bg = p.bg_highlight },
    CursorLineNr = { fg = p.primary, bold = true },
    LineNr = { fg = p.line_nr },
    SignColumn = { bg = p.bg },
    ColorColumn = { bg = p.bg_highlight },

    Visual = { bg = p.selection },
    Search = { fg = p.base, bg = p.search },
    IncSearch = { fg = p.base, bg = p.match },
    CurSearch = { fg = p.base, bg = p.match },
    MatchParen = { fg = p.tertiary, bold = true },

    Pmenu = { fg = p.fg, bg = p.bg_alt },
    PmenuSel = { fg = p.base, bg = p.primary },
    PmenuSbar = { bg = p.bg_highlight },
    PmenuThumb = { bg = p.border },

    StatusLine = { fg = p.fg, bg = p.bg_alt },
    StatusLineNC = { fg = p.fg_dim, bg = p.bg },
    WinSeparator = { fg = p.border },
    VertSplit = { fg = p.border },

    TabLine = { fg = p.fg_dim, bg = p.bg_alt },
    TabLineSel = { fg = p.fg, bg = p.bg_highlight, bold = true },
    TabLineFill = { bg = p.bg_alt },

    Title = { fg = p.primary, bold = true },
    Directory = { fg = p.secondary },

    Comment = { fg = p.comment, italic = true },
    Constant = { fg = p.tertiary },
    String = { fg = p.success },
    Character = { fg = p.success },
    Number = { fg = p.tertiary },
    Boolean = { fg = p.tertiary },
    Identifier = { fg = p.fg },
    Function = { fg = p.primary },
    Statement = { fg = p.secondary },
    Keyword = { fg = p.secondary },
    Operator = { fg = p.fg_dim },
    PreProc = { fg = p.secondary },
    Type = { fg = p.tertiary },
    Special = { fg = p.primary },
    Underlined = { underline = true },
    Error = { fg = p.error, bold = true },

    ErrorMsg = { fg = p.error },
    WarningMsg = { fg = p.warning },
    MoreMsg = { fg = p.success },
    Question = { fg = p.info },

    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warning },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.success },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warning },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.success },

    DiffAdd = { fg = p.success, bg = p.bg_highlight },
    DiffChange = { fg = p.warning, bg = p.bg_highlight },
    DiffDelete = { fg = p.error, bg = p.bg_highlight },
    DiffText = { fg = p.base, bg = p.warning },
  }

  for name, value in pairs(groups) do
    vim.api.nvim_set_hl(0, name, value)
  end
end

M.apply = apply

apply()

-- Matugen rewrites the palette file whenever the wallpaper changes. Watch
-- the directory (not the file) so the watcher also catches the first write.
local uv = vim.uv or vim.loop
if uv then
  local watch_dir = vim.fn.stdpath("config") .. "/lua"
  local handle = uv.new_fs_event()
  if handle then
    local ok = pcall(handle.start, handle, watch_dir, {}, function(err, filename)
      if not err and (filename == nil or filename == "matugen.lua") then
        vim.schedule(apply)
      end
    end)
    if ok then
      M._watcher = handle
    else
      handle:close()
    end
  end
end

return M
