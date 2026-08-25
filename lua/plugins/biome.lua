return {
  -- Biome (Rust) instead of prettier for the web filetypes it actually covers.
  --
  -- Scope is deliberate: biome handles JS/TS/JSX/JSON/CSS/GraphQL, but NOT
  -- markdown or yaml, which the prettier extra also formats. So prettier stays
  -- enabled and keeps those; only the filetypes below are moved.
  --
  -- stop_after_first means conform runs biome and stops when it succeeds, and
  -- falls through to prettier if biome is missing -- so a machine without the
  -- biome binary still formats, just more slowly.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "biome")
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
        css = { "biome", "prettier", stop_after_first = true },
        graphql = { "biome", "prettier", stop_after_first = true },
      },
    },
  },
}
