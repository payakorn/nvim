-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Keep .tex out of format-on-save.
--
-- tex-fmt is wired up in lua/plugins/tex.lua, but running it on every write
-- would rewrite most of a manuscript at once -- and the paper repo is synced
-- with Overleaf, where that collides with incoming commits. LazyVim checks
-- vim.b.autoformat per buffer, so this leaves <leader>cf working on demand
-- while :w leaves the file alone.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("tex_no_autoformat", { clear = true }),
  pattern = { "tex", "plaintex", "bib" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Show raw quotes in JSON (LazyVim's default conceallevel is 2), and raw LaTeX in
-- tex/bib: vimtex's concealed math broke the screen in Thai chapters (stale
-- duplicate lines until a scroll redrew them; 2026-11-14). Markdown is not
-- listed: render-markdown.nvim sets its own conceallevel and would win anyway
-- (<leader>um toggles the rendered view).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_conceal", { clear = true }),
  pattern = { "json", "jsonc", "tex", "plaintex", "bib" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

