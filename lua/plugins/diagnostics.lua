return {
  -- Make long diagnostics readable.
  --
  -- LazyVim's default renders diagnostics as virtual_text: appended inline
  -- after the code on the same row. LaTeX servers emit long messages --
  -- "Package natbib Warning: Citation `foo' on page 5 undefined on input
  -- line 541." -- which run past the window edge and are silently clipped,
  -- with no way to scroll to the rest.
  --
  -- virtual_lines (Neovim 0.11+) instead renders the diagnostic on its own
  -- line(s) below the code, wrapped in full. Scoped to current_line so the
  -- buffer is not permanently pushed apart by every warning -- the message
  -- expands only on the row the cursor is on.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = { current_line = true },
      },
    },
  },
}
