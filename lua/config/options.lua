-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Show non-LSP snippets (mini.snippets / friendly-snippets) in the completion menu.
-- See :h MiniSnippets-session for expanding them.
vim.g.lazyvim_mini_snippets_in_completion = true

-- Show Copilot suggestions as inline ghost text instead of as entries in the
-- nvim-cmp menu. With ai_cmp = true (LazyVim's default) the copilot-cmp source
-- is injected at the top of the completion menu and multi-line suggestions get
-- truncated to a single row; false enables copilot.lua's own inline preview.
-- <Tab> accepts, <M-]>/<M-[> cycle. Must be set before plugins are evaluated.
vim.g.ai_cmp = false

-- Python: basedpyright for types/hover/go-to-definition, ruff for lint/format.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Julia language server, run from its own environment instead of Mason.
-- Install once with:
--   julia --project=~/.julia/environments/lsp/ -e 'using Pkg; Pkg.add("LanguageServer")'
vim.lsp.config("julials", {
  cmd = {
    "julia",
    -- expanded here: cmd is run without a shell, so "~" would reach julia literally
    "--project=" .. vim.fn.expand("~/.julia/environments/lsp/"),
    "--startup-file=no",
    "--history-file=no",
    "-e",
    [[
      using Pkg
      Pkg.instantiate()
      using LanguageServer
      project_path = let
        dirname(something(
          ## 1. an explicitly set project (JULIA_PROJECT)
          Base.load_path_expand((
            p = get(ENV, "JULIA_PROJECT", nothing);
            p === nothing ? nothing : isempty(p) ? nothing : p
          )),
          ## 2. a Project.toml in the working directory or a parent, up to $HOME
          Base.current_project(),
          ## 3. the first entry in the load path
          get(Base.load_path(), 1, nothing),
          ## 4. the default global environment (more or less unreachable)
          Base.load_path_expand("@v#.#"),
        ))
      end
      @info "Running language server" VERSION pwd() project_path
      # LanguageServer >= 6 dropped the depot_path argument and the runlinter field
      server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path)
      run(server)
    ]],
  },
  filetypes = { "julia" },
  root_markers = { "Project.toml", "JuliaProject.toml" },
  settings = {},
})
vim.lsp.enable("julials")
