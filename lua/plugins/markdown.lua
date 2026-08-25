return {
  -- markdownlint's defaults are tuned for terse docs, not prose: across the
  -- .md files in ~/projects/srt_scripts it produced 358 diagnostics, 336 of
  -- them MD013/line-length alone (it wants a hard 80-column wrap). That buries
  -- anything worth reading, so drop markdown from nvim-lint entirely.
  --
  -- LazyVim only substitutes the "_" fallback linters when the resolved list
  -- is empty, and leaves both "_" and "*" unset, so an explicit empty list
  -- means no linter runs for markdown.
  --
  -- marksman (LSP) is deliberately left alone: it reports broken links and
  -- bad references, which are real errors rather than style opinions.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
      return opts
    end,
  },
}
