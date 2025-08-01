-- if true then
--   return {}
-- end
return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    color_overrides = {
      macchiato = {
        rosewater = "#F5B8AB",
        flamingo = "#F29D9D",
        pink = "#AD6FF7",
        mauve = "#FF8F40",
        red = "#E66767",
        maroon = "#EB788B",
        peach = "#FAB770",
        yellow = "#FACA64",
        green = "#70CF67",
        teal = "#4CD4BD",
        sky = "#61BDFF",
        sapphire = "#4BA8FA",
        blue = "#00BFFF",
        lavender = "#00BBCC",
        text = "#C1C9E6",
        subtext1 = "#A3AAC2",
        subtext0 = "#8E94AB",
        overlay2 = "#7D8296",
        overlay1 = "#676B80",
        overlay0 = "#464957",
        surface2 = "#3A3D4A",
        surface1 = "#2F313D",
        surface0 = "#1D1E29",
        base = "#0b0b12",
        mantle = "#11111a",
        crust = "#191926",
      },
      mocha = {
        -- base = "#000000",
        -- mantle = "#000000",
        -- crust = "#000000",

        -- this 16 colors are changed to onedark
        base = "#282c34",
        mantle = "#353b45",
        surface0 = "#3e4451",
        surface1 = "#545862",
        surface2 = "#565c64",
        text = "#abb2bf",
        rosewater = "#b6bdca",
        lavender = "#c8ccd4",
        red = "#e06c75",
        peach = "#d19a66",
        yellow = "#e5c07b",
        green = "#98c379",
        teal = "#56b6c2",
        blue = "#61afef",
        mauve = "#c678dd",
        flamingo = "#be5046",

        -- now patching extra palettes
        maroon = "#e06c75",
        sky = "#d19a66",

        -- extra colors not decided what to do
        pink = "#F5C2E7",
        sapphire = "#74C7EC",

        subtext1 = "#BAC2DE",
        subtext0 = "#A6ADC8",
        overlay2 = "#9399B2",
        overlay1 = "#7F849C",
        overlay0 = "#6C7086",

        crust = "#11111B",
      },
    },
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      snacks = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
          opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
        end
      end,
    },
  },
}
