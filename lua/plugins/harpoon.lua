return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>H",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }
    for i = 1, 5 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end

    -- Add <C-e> fzf-lua integration key here so Lazy registers it
    table.insert(keys, {
      "<C-e>",
      function()
        local harpoon = require("harpoon")
        local fzf = require("fzf-lua")

        local file_paths = {}
        for _, item in ipairs(harpoon:list().items) do
          table.insert(file_paths, item.value)
        end

        fzf.fzf_exec(file_paths, {
          prompt = "Harpoon> ",
          previewer = "builtin",
          -- reuse fzf-lua's own file actions: enter/ctrl-s/ctrl-v/ctrl-t etc.
          actions = fzf.defaults.actions.files,
        })
      end,
      desc = "Harpoon (fzf-lua)",
      mode = "n",
    })

    return keys
  end,

  config = function(_, opts)
    -- Setup harpoon with your opts
    local harpoon = require("harpoon")
    harpoon:setup(opts)
  end,
}
