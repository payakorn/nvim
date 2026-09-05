-- Searchable cheatsheet: KEYS.md, parsed into an fzf-lua picker.
-- The markdown file stays the single source of truth — edit it, and this
-- picker changes with it.

local KEYS_MD = vim.fn.stdpath("config") .. "/KEYS.md"

-- Split a markdown table row on its unescaped pipes, so a cell may hold a
-- literal `\|` — regex alternation would otherwise cut the row in half.
local function cells(line)
  if not line:find("^|") then
    return nil
  end
  local out, buf, i = {}, "", 2
  while i <= #line do
    local c = line:sub(i, i)
    if c == "\\" and line:sub(i + 1, i + 1) == "|" then
      buf, i = buf .. "|", i + 2
    elseif c == "|" then
      out[#out + 1], buf, i = vim.trim(buf), "", i + 1
    else
      buf, i = buf .. c, i + 1
    end
  end
  return out
end

-- `]d` / `[d` and `<leader>1` … `<leader>5` list alternatives; only the first
-- one is a key we can replay
local function first_alt(text)
  for _, sep in ipairs({ "%s+/%s+", "%s+…%s+" }) do
    text = vim.split(text, sep)[1]
  end
  return text
end

-- Turn every `| `key` | action |` row of KEYS.md into an entry, tagged with the
-- `##` / `###` heading it lives under.
local function parse()
  local ok, lines = pcall(vim.fn.readfile, KEYS_MD)
  if not ok then
    return {}
  end

  local items, h2, h3 = {}, "", ""
  for lnum, line in ipairs(lines) do
    local level, title = line:match("^(#+)%s+(.*)")
    if level then
      title = title:gsub("`", "")
      if #level == 2 then
        h2, h3 = title, ""
      elseif #level == 3 then
        h3 = title
      end
    end

    local row = cells(line) or {}
    local key, action = row[1], row[2]
    -- two columns and a backtick in the first is what separates a real binding
    -- row from the header, the `| --- |` rule, and the language-tooling table
    if #row == 2 and key:find("`") then
      -- `` ` `` is how markdown escapes a literal backtick key: keep what is
      -- inside the double fence, otherwise just drop the code-span backticks
      local fenced = key:match("^``%s*(.-)%s*``$")
      local text = fenced and fenced:gsub("``", "`") or key:gsub("`", "")
      items[lnum] = {
        lnum = lnum,
        section = h3 ~= "" and (h2 .. " › " .. h3) or h2,
        key = text,
        -- strip emphasis only: **(custom)** and *(insert mode)*, never the
        -- star in \section*
        action = action:gsub("%*%*", ""):gsub("%*(%S[^*]*)%*", "%1"):gsub("`", ""),
        -- what to actually feed vim: the first alternative of `]d` / `[d`.
        -- Reference sections list patterns, not keys — nothing to press.
        raw = h2 ~= "Regex" and first_alt(text) or nil,
      }
    end
  end
  return items
end

-- `<leader>sg` → " sg", so nvim_feedkeys replays it exactly as typed
local function to_keys(str)
  local function sub(pat, leader)
    leader = (leader == nil or leader == "") and " " or leader
    -- % is the escape in a gsub replacement, not the pattern
    str = str:gsub(pat, (leader:gsub("%%", "%%%%")))
  end
  sub("<leader>", vim.g.mapleader)
  sub("<localleader>", vim.g.maplocalleader)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function open()
  local fzf = require("fzf-lua")
  local ansi = require("fzf-lua.utils").ansi_codes

  local items = parse()
  if vim.tbl_isempty(items) then
    return vim.notify("No key tables found in " .. KEYS_MD, vim.log.levels.WARN)
  end

  local key_w, action_w = 0, 0
  for _, it in pairs(items) do
    key_w = math.max(key_w, vim.fn.strdisplaywidth(it.key))
    action_w = math.max(action_w, vim.fn.strdisplaywidth(it.action))
  end
  -- a handful of long notes should not push the section column off screen
  action_w = math.min(action_w, 56)

  local function pad(str, w)
    return str .. string.rep(" ", math.max(w - vim.fn.strdisplaywidth(str), 0))
  end

  -- entries are grep-shaped (file:line:col:text) so fzf-lua's builtin previewer
  -- can show the surrounding section of KEYS.md; --with-nth hides the prefix
  local entries = {}
  for _, it in vim.spairs(items) do
    entries[#entries + 1] = table.concat({
      KEYS_MD,
      it.lnum,
      1,
      ansi.yellow(pad(it.key, key_w)) .. "  " .. pad(it.action, action_w) .. "  " .. ansi.grey(it.section),
    }, ":")
  end

  local function selected_item(selected)
    local lnum = tonumber(selected[1]:match("^.-:(%d+):"))
    return items[lnum]
  end

  fzf.fzf_exec(entries, {
    prompt = "Keys❯ ",
    previewer = "builtin",
    winopts = { title = " KEYS.md ", preview = { layout = "vertical", vertical = "down:45%" } },
    fzf_opts = {
      ["--ansi"] = true,
      ["--delimiter"] = ":",
      ["--with-nth"] = "4..",
      ["--no-multi"] = true,
      ["--header"] = ":: <enter> show  <ctrl-x> run it  <ctrl-o> open KEYS.md",
    },
    actions = {
      -- default: no side effects — put the binding on screen and in a register
      -- so you can read it while you type it yourself
      ["default"] = function(selected)
        local it = selected_item(selected)
        if not it then
          return
        end
        vim.fn.setreg('"', it.raw or it.key)
        vim.notify(it.key .. "   " .. it.action, vim.log.levels.INFO, { title = "KEYS.md" })
      end,
      ["ctrl-x"] = function(selected)
        local it = selected_item(selected)
        if it and it.raw then
          vim.api.nvim_feedkeys(to_keys(it.raw), "m", false)
        end
      end,
      ["ctrl-o"] = function(selected)
        local it = selected_item(selected)
        vim.cmd.edit(KEYS_MD)
        if it then
          vim.api.nvim_win_set_cursor(0, { it.lnum, 0 })
          vim.cmd("normal! zz")
        end
      end,
    },
  })
end

return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>sK", open, desc = "Keys cheatsheet (KEYS.md)" },
  },
}
