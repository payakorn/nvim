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

  -- texlab: force full-document sync, and use the Homebrew binary.
  --
  -- texlab panics in did_change and dies with exit code 101 --
  --   crates/texlab/src/server.rs:422: offset_lsp_range(range).unwrap()
  -- -- when an incremental edit range does not map into its line index.
  -- This was first blamed on Mason's pinned 5.23.1 (same unwrap, then at
  -- server.rs:396), but brew's 5.26.0 panics identically: the bug is upstream
  -- and still open, so mason = false alone never fixed it.
  --
  -- The trigger is a buffer with no trailing newline. Neovim marks it 'noeol'
  -- and sends didOpen text ending mid-line, but its incremental sync still
  -- reports edits on the last line as ending at {line = <count>, character = 0}
  -- -- one position past what the server holds. Other servers clamp that;
  -- texlab unwraps None. The paper repo is synced with Overleaf, which is free
  -- to drop the final newline again, so fixing the file is not enough.
  --
  -- Overriding textDocumentSync.change to 1 (Full) in on_init -- before the
  -- first didOpen -- removes ranges from the wire entirely, so the unwrap can
  -- never be reached. Cost is resending the whole buffer per keystroke (~90KB
  -- for main.tex), which is nothing over a local pipe and is what texlab's
  -- reparse does anyway.
  -- No inlay hints in LaTeX: texlab writes each \label's number and each \ref's
  -- target as grey text inside the line, which made the Thai chapters hard to
  -- read (2026-11-14).
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { exclude = { "vue", "tex", "plaintex", "bib" } },
      servers = {
        texlab = {
          mason = false,
          on_init = function(client)
            local sync = client.server_capabilities.textDocumentSync
            if type(sync) == "table" then
              sync.change = 1 -- TextDocumentSyncKind.Full
            else
              client.server_capabilities.textDocumentSync = { openClose = true, change = 1 }
            end
          end,
        },
      },
    },
  },
  -- PDF viewer with SyncTeX, both ways: \lv shows the cursor's line in the PDF,
  -- Ctrl+click in the PDF jumps back to that line here. Skim on the Mac; on Linux
  -- zathura_simple (the plain "zathura" method needs xdotool, which Wayland lacks).
  -- The engine comes from each project's .latexmkrc (206255/notes sets xelatex).
  {
    "lervag/vimtex",
    init = function()
      if vim.fn.has("mac") == 1 then
        vim.g.vimtex_view_method = "skim"
      else
        vim.g.vimtex_view_method = "zathura_simple"
      end
    end,
  },
}
