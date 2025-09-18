return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "astro",
        "cmake",
        "cpp",
        "css",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "http",
        "java",
        "php",
        "rust",
        "scss",
        "sql",
        "svelte",
        "julia",
        "python",
        "markdown",
        "markdown_inline",
        "lua",
        "vim",
        "vimdoc",
        "query",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    --
    --   -- MDX
    --   vim.filetype.add({ extension = { mdx = "mdx" } })
    --   vim.treesitter.language.register("markdown", "mdx")
    -- end,
  },
}
