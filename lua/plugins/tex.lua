return {
  -- Format .tex with tex-fmt (Rust) -- but never on save.
  --
  -- tex-fmt's default line wrapping turns the paper's main.tex from 1065 lines
  -- into 1955, rewriting 2019 lines. --nowrap brings that down to 655 changed
  -- lines, which is still most of the file. That repo is synced with Overleaf
  -- (it takes "Updates from Overleaf" commits), so silently reformatting on
  -- every :w would collide with incoming syncs and bury real edits in noise.
  --
  -- So the formatter is on-demand only: <leader>cf when you actually want it,
  -- with format-on-save disabled for tex buffers in config/autocmds.lua.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
        plaintex = { "tex-fmt" },
      },
      formatters = {
        ["tex-fmt"] = {
          -- without this every paragraph is re-wrapped at 80 columns
          prepend_args = { "--nowrap" },
        },
      },
    },
  },
}
