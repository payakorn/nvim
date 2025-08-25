return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- ensure telescope is available
  },
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

    -- Add <C-e> Telescope integration key here so Lazy registers it
    table.insert(keys, {
      "<C-e>",
      function()
        local harpoon = require("harpoon")
        local conf = require("telescope.config").values

        local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end

          require("telescope.pickers")
            .new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({ results = file_paths }),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
            })
            :find()
        end

        toggle_telescope(harpoon:list())
      end,
      desc = "Harpoon Telescope",
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
