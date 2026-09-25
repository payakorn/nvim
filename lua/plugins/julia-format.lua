-- Format Julia with JuliaFormatter's `jlfmt` at 2-space indent instead of the
-- language server's built-in formatter, which has no global config and always
-- uses 4 spaces unless each repo carries a JuliaFormat.toml.
-- Install jlfmt once with: julia -e 'using Pkg; Pkg.Apps.add("JuliaFormatter")'
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      julia = { "jlfmt" },
    },
    formatters = {
      jlfmt = {
        command = vim.fn.expand("~/.julia/bin/jlfmt"),
        args = { "--style=minimal", "--indent=2", "--stdin-filename=$FILENAME", "-" },
        -- jlfmt starts a Julia process per call (~1.3 s), inside LazyVim's 3 s format timeout
        stdin = true,
      },
    },
  },
}
