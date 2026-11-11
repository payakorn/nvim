-- Statusline colors follow the colorscheme ("auto"), so it matches both
-- Catppuccin Mocha (dark) and Rose Pine Dawn (light); lualine reloads the theme
-- on every ColorScheme event, so a live light/dark switch recolors it too.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lazy_status = require("lazy.status") -- pending plugin updates count

    require("lualine").setup({
      options = {
        theme = "auto",
      },
      sections = {
        lualine_a = {
          { "mode", color = { gui = "italic" } },
        },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = "DiagnosticWarn",
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
