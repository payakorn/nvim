-- Light theme: Rose Pine Dawn, the same as Ghostty and tmux in light mode.
-- Dark stays Catppuccin Mocha (onedark-patched, see catppuccin.lua).
-- The switch itself is in lua/config/theme.lua.
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "dawn",
      dark_variant = "main",
      styles = { italic = false },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("config.theme").apply()
      end,
    },
  },
}
