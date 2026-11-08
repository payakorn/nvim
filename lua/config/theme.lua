-- Follow the terminal's light/dark theme, like Ghostty and tmux.
--
-- Neovim reads the terminal background at startup (OSC 11) and, from 0.11,
-- updates 'background' when the terminal reports a theme change (mode 2031,
-- passed on by tmux 3.6+). Here we pick the matching colorscheme each time.
local M = {}

M.schemes = { light = "rose-pine-dawn", dark = "catppuccin-mocha" }

function M.apply()
  local want = M.schemes[vim.o.background] or M.schemes.dark
  -- rose-pine-dawn reports colors_name "rose-pine", so remember our own pick.
  if M.current ~= want or not vim.g.colors_name then
    M.current = want
    vim.cmd.colorscheme(want)
  end
end

vim.api.nvim_create_autocmd("OptionSet", {
  group = vim.api.nvim_create_augroup("follow_terminal_theme", { clear = true }),
  pattern = "background",
  callback = function()
    -- schedule: the colorscheme itself sets 'background'; the guard in
    -- apply() stops that from looping.
    vim.schedule(M.apply)
  end,
})

return M
