-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Set to `false` to prevent "non-lsp snippets"" from appearing inside completion windows
-- Motivation: Less clutter in completion windows and a more direct usage of snippits
vim.g.lazyvim_mini_snippets_in_completion = true

-- NOTE: Please also read:
-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-snippets.md#expand
-- :h MiniSnippets-session

-- Example override for your own config:
--[[
return {
{
"echasnovski/mini.snippets",
opts = function(_, opts)
-- By default, for opts.snippets, the extra for mini.snippets only adds gen_loader.from_lang()
-- This provides a sensible quickstart, integrating with friendly-snippets
-- and your own language-specific snippets
--
-- In order to change opts.snippets, replace the entire table inside your own opts

local snippets, config_path = require("mini.snippets"), vim.fn.stdpath("config")

opts.snippets = { -- override opts.snippets provided by extra...
-- Load custom file with global snippets first (order matters)
snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),

-- Load snippets based on current language by reading files from
-- "snippets/" subdirectories from 'runtimepath' directories.
snippets.gen_loader.from_lang(), -- this is the default in the extra...
}
end,
},
}
--]]
---- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
-- vim.g.lazyvim_python_lsp = "black"
-- Set to "ruff_lsp" to use the old LSP implementation version.
--
vim.g.lazyvim_python_lsp = "ruff_lsp"
vim.g.lazyvim_python_ruff = "ruff"

vim.lsp.enable("julials")
-- use this to install julials and Disable from mason
-- julia --project=@nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'

-- set mouse
-- opt.mouse = "a"

vim.lsp.config("julials", {
  cmd = {
    "julia",
    "--project=" .. "~/.julia/environments/lsp/",
    "--startup-file=no",
    "--history-file=no",
    "-e",
    [[
            using Pkg
            Pkg.instantiate()
            using LanguageServer
        depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
        project_path = let
            dirname(something(
                ## 1. Finds an explicitly set project (JULIA_PROJECT)
                Base.load_path_expand((
                    p = get(ENV, "JULIA_PROJECT", nothing);
                        p === nothing ? nothing : isempty(p) ? nothing : p
                    )),
                        ## 2. Look for a Project.toml file in the current working directory,
                        ##    or parent directories, with $HOME as an upper boundary
                        Base.current_project(),
                        ## 3. First entry in the load path
                        get(Base.load_path(), 1, nothing),
                        ## 4. Fallback to default global environment,
                        ##    this is more or less unreachable
                    Base.load_path_expand("@v#.#"),
                ))
            end
                    @info "Running language server" VERSION pwd() project_path depot_path
                    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
        server.runlinter = true
            run(server)
        ]],
  },
  filetypes = { "julia" },
  root_markers = { "Project.toml", "JuliaProject.toml" },
  settings = {},
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
