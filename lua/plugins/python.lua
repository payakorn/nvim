return {
  -- Tone down basedpyright: its default "recommended" mode flags
  -- reportAny / reportUnknown* on every untyped line. "basic" reports
  -- only clear type errors while keeping hover, go-to-def and completion.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },

  -- Format with ruff instead of black.
  --
  -- The ruff LSP was already doing the linting (F401/F841 etc), but the
  -- formatting.black extra set conform's python formatter to black, so the
  -- slow Python tool was reformatting what the fast Rust one had just linted.
  -- `ruff format` is a black-compatible formatter, so output style is
  -- unchanged. The extra is removed from lazyvim.json; without this block
  -- python would be left with no formatter at all, since lang.python sets none.
  --
  -- ruff_organize_imports replaces what isort/black-profile did for imports.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },
}
