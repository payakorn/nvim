return {
  -- Give ]] / [[ back to vimtex's section motions in .tex files.
  --
  -- LazyVim maps them to Snacks.words "Next/Prev Reference" for any LSP that
  -- advertises documentHighlight, and texlab does. vimtex only claims a key
  -- while it is still free (the `empty(maparg(...))` guard in
  -- autoload/vimtex.vim), so the LSP mapping won and ]] jumped between
  -- references instead of sections. Re-mapping afterwards on LspAttach loses
  -- to callback ordering, so disabling the LSP mapping is the deterministic
  -- fix.
  --
  -- Nothing is actually lost: LazyVim maps the same Snacks.words jumps to
  -- <a-n> / <a-p>, which stay untouched.
  --
  -- Set via servers['*'].keys -- the older
  -- require("lazyvim.plugins.lsp.keymaps").get() route is deprecated and warns.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            -- ]] / [[ go back to vimtex (see above)
            { "]]", false },
            { "[[", false },

            -- Snacks.words reference jumping moves off <a-n>/<a-p>: Option is a
            -- compose key on macOS, so those need macos-option-as-alt and are
            -- awkward to reach. ]r / [r were free and match the neighbouring
            -- bracket motions -- ]d diagnostic, ]h hunk, ]q quickfix, ]t todo.
            { "<a-n>", false },
            { "<a-p>", false },
            {
              "]r",
              function()
                Snacks.words.jump(vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Next Reference",
              enabled = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "[r",
              function()
                Snacks.words.jump(-vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Prev Reference",
              enabled = function()
                return Snacks.words.is_enabled()
              end,
            },
          },
        },
      },
    },
  },
}
