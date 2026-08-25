-- macOS gives each user a ~49-char $TMPDIR, so nvim's default stdpath("run")
-- (/var/folders/../T/nvim.<user>/XXXXXX) is already 78 chars. Unix sockets cap
-- sun_path at 104 bytes, leaving too little room for plugin-created sockets:
-- fzf-lua's serverstart("fzf-lua." .. os.time()) overflows it and aborts startup
-- with "Failed to start server: invalid argument". Point XDG_RUNTIME_DIR at a
-- short private dir instead. Must run before any plugin loads.
if vim.fn.has("mac") == 1 and (vim.env.XDG_RUNTIME_DIR or "") == "" then
  local uid = vim.uv.getuid()
  local dir = "/tmp/nvim-" .. uid
  pcall(vim.fn.mkdir, dir, "p", tonumber("700", 8))
  local stat = vim.uv.fs_stat(dir)
  if stat and stat.type == "directory" and stat.uid == uid then
    vim.env.XDG_RUNTIME_DIR = dir
  end
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
