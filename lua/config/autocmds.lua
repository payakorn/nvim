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

-- LaTeX and BibTeX buffers: the paper keeps one paragraph per line, so soft
-- wrap at word boundaries is what makes the text readable, with j/k moving by
-- screen line. Spell-check is off: <leader>us toggles it on when wanted.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("tex_prose", { clear = true }),
  pattern = { "tex", "plaintex", "bib" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0
    vim.opt_local.spell = false
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.conceallevel = 0
    vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true })
    vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true })
  end,
})
