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
}
