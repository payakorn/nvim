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

  -- Use the Homebrew texlab, not Mason's.
  --
  -- Mason was pinned at 5.23.1 (June 2025), four releases behind. That build
  -- panics in did_change --
  --   crates/texlab/src/server.rs:396: offset_lsp_range(range).unwrap()
  -- -- when an incremental edit range fails to map into its line index, taking
  -- the whole server down with exit code 101 instead of recovering.
  --
  -- mason = false stops LazyVim installing or launching Mason's copy, so the
  -- brew binary (5.26.0) on PATH is used instead.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          mason = false,
          settings = {
            texlab = {
              -- building stays with vimtex; chktex is off because its style
              -- opinions (dash lengths, spacing after commands, ...) flag
              -- nearly every line of a manuscript and bury real problems
              build = { onSave = false },
              chktex = { onOpenAndSave = false, onEdit = false },
              latexindent = { modifyLineBreaks = false },
            },
          },
        },
      },
    },
  },

  -- vimtex on top of LazyVim's lang.tex extra.
  --
  -- Viewer: zathura, the one viewer that does both directions of SyncTeX with
  -- vimtex on Wayland without extra tooling: <localleader>lv jumps from the
  -- cursor to the PDF, Ctrl+click in the PDF jumps back to the source line.
  -- Linux: sudo pacman -S zathura zathura-pdf-mupdf. macOS: Skim instead.
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = vim.fn.has("mac") == 1 and "skim" or "zathura"

      -- latexmk in continuous mode (<localleader>ll toggles it), same flags as
      -- the paper's CI build plus synctex for the viewer.
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "",
        out_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-file-line-error",
        },
      }

      -- Quickfix opens on real errors only, and the box warnings are dropped:
      -- they are checked deliberately (see the paper's \emergencystretch note),
      -- not on every save.
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull \\\\hbox",
        "Overfull \\\\hbox",
        "Underfull \\\\vbox",
        "Overfull \\\\vbox",
        "Package hyperref Warning",
      }

      -- Show the source as written; no unicode substitution of \alpha, \cite etc.
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Table of contents in a narrow left split (<localleader>lt).
      vim.g.vimtex_toc_config = {
        split_pos = "vert leftabove",
        split_width = 36,
        show_help = 0,
        layer_status = { label = 0, include = 0 },
      }
    end,
  },
}
