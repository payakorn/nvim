# Keys

Keybinding reference for this config, focused on editing `.tex` and Python.
Every key here was read off a live buffer with the LSP attached, not copied from
documentation.

- **leader** = <kbd>Space</kbd>
- **localleader** = <kbd>\\</kbd>

Bindings marked **(custom)** differ from stock LazyVim — see `lua/plugins/` for
the spec and the commit message for why.

---

## LaTeX

`vimtex`, `.tex` buffers.

| Key | Action |
| --- | --- |
| `\lt` | Table of contents — jump to any section |
| `]]` / `[[` | Next / previous section **(custom)** |
| `][` / `[]` | Next / previous section *end* |
| `<leader>cf` | Format the file with `tex-fmt` **(custom)** |
| `\ll` | Compile — **needs `latexmk`, not currently installed** |

Counts work: `4]]` skips four sections.

`.tex` never formats on save, on purpose — `tex-fmt` rewrites ~655 lines of a
manuscript at once, and the paper repo syncs with Overleaf. `<leader>uf` toggles
autoformat per buffer if you want it temporarily.

### Structure edits

| Key | Action |
| --- | --- |
| `cse` | Change surrounding environment — `equation` → `align` |
| `dse` | Delete environment, keep the contents |
| `csc` / `dsc` | Change / delete surrounding command |
| `tse` | Toggle starred — `\section` ↔ `\section*` |
| `ie` / `ae` | Environment — `dae` deletes a whole table |
| `i$` / `a$` | Inline math |
| `ic` / `ac` | Command |
| `id` / `ad` | Delimiter — `\left( … \right)` |
| `iP` / `aP` | Section / part |

### References and citations

`texlab` (5.26.0, installed via Homebrew rather than Mason).

| Key | Action |
| --- | --- |
| `\ref{` | Type it in insert mode — completion lists every label |
| `\cite{` | Same, against the `.bib` |
| `gd` | On a `\ref` → its `\label`; on a `\cite` → the bib entry |
| `gr` | On a `\label` → every `\ref` pointing at it |

Use `gr` before renaming a label — it shows every use first.

---

## Find and jump

`fzf-lua` is the picker (telescope was removed).

| Key | Action |
| --- | --- |
| `<leader><leader>` | Find files in the project |
| `<leader>ss` | Go to symbol — fuzzy-jump sections |
| `<leader>sb` | Search lines in this buffer |
| `<leader>sg` | Grep the project |
| `<leader>sw` | Grep the word under the cursor |
| `<leader>e` | File explorer |
| `s` / `S` | Leap forward / backward — then two characters |

### When you cannot remember a key

| Key | Action |
| --- | --- |
| `<leader>sk` | Every keymap live in this session, with its description |
| `<leader>sK` | This file as a picker — search by key or by wording **(custom)** |
| `<leader>` | Wait a moment — which-key lists what can follow |
| `:verbose map <key>` | Which file set this key, and to what |

`<leader>sk` is the ground truth: it reads the mappings Neovim actually holds.
`<leader>sK` reads *this file*, so it carries the notes, the **(custom)** marks
and the regex tables below. `Enter` echoes the entry and yanks it, `<C-x>` runs
the key, `<C-o>` opens KEYS.md at that row. It is `lua/plugins/keys-cheatsheet.lua`,
and it re-parses on every open — add a row here and the picker has it.

## Pinned files

`harpoon`.

| Key | Action |
| --- | --- |
| `<leader>H` | Pin the current file |
| `<leader>h` | Quick menu of pinned files |
| `<leader>1` … `<leader>5` | Jump straight to pin 1–5 |
| `<C-e>` | Pinned files as an fzf-lua picker **(custom)** |

The picker takes fzf-lua's standard file keys: `Enter` open, `<C-s>` split,
`<C-v>` vsplit, `<C-t>` tab.

## Code

LSP, any language.

| Key | Action |
| --- | --- |
| `K` | Hover docs |
| `gd` | Go to definition |
| `gr` | List references |
| `gI` / `gy` | Implementation / type definition |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>xx` | All diagnostics (Trouble) |

## Step through things

One family, one logic.

| Key | Action |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `]r` / `[r` | Next / previous reference of this symbol **(custom)** |
| `]q` / `[q` | Next / previous quickfix item |
| `]h` | Next git hunk |
| `]t` | Next TODO comment |

`]r` replaces LazyVim's `<a-n>`/`<a-p>`, which need <kbd>Option</kbd> to be sent
as Alt on macOS and are awkward to reach.

## AI

`copilot.lua` for inline completion, `claudecode.nvim` for the agent.

| Key | Action |
| --- | --- |
| `<Tab>` | Accept the grey inline suggestion *(insert mode)* **(custom)** |
| `<M-]>` / `<M-[>` | Cycle to another suggestion |
| `<leader>ac` | Open / close Claude Code |
| `<leader>ab` | Send this buffer as context |
| `<leader>as` | Send the selection *(visual mode)* |
| `<leader>aa` / `<leader>ad` | Accept / reject a proposed diff |
| `<leader>ar` / `<leader>aC` | Resume / continue a session |

Copilot renders as inline ghost text rather than as entries in the completion
menu — that is `vim.g.ai_cmp = false` in `lua/config/options.lua`.

## Regex

Nothing here is a key to press — these rows are in the `<leader>sK` picker so a
pattern you half-remember is one search away. `Enter` yanks the pattern.

### Vim search — `/` and `?`

| Pattern | Meaning |
| --- | --- |
| `\v` | Very magic — `(`, `\|`, `+`, `?`, `{}` work as in PCRE. Start here |
| `\V` | Very nomagic — everything literal but `\`. For searching LaTeX |
| `\<` / `\>` | Word start / end — `\vword>` matches the word, not the prefix |
| `\zs` / `\ze` | Match starts / ends here; the rest is only context |
| `\{-}` | Non-greedy `*` — `\v\{.\{-}\}` stops at the first `}` |
| `\%(...\)` | Group without capturing |
| `\v(x)@=` / `(x)@!` | Lookahead / negative lookahead |
| `\v(x)@<=` / `(x)@<!` | Lookbehind / negative lookbehind |
| `\c` / `\C` | Case-insensitive / sensitive, anywhere in the pattern |
| `\_s` / `\_.` | Whitespace / any character, newline included |
| `*` / `#` | Search the word under the cursor forward / backward |
| `q/` | Search history in a real window you can edit and re-run |

`\v` first is the habit worth building: `\v(align|equation)\*?` instead of
`\(align\|equation\)\*\=`.

### Substitute

| Pattern | Meaning |
| --- | --- |
| `:%s/old/new/g` | Every match in the file |
| `:%s//new/g` | Empty pattern reuses the last search — search first, then fix |
| `:%s/x/y/gc` | Confirm each: `y` `n` `a` skip-all `l` last `q` quit |
| `:'<,'>s/x/y/g` | Only the visual selection |
| `\0` `\1` … `\9` | Whole match / capture groups, in the replacement |
| `~` | The previous replacement text |
| `\U` `\L` `\E` | Upper-case / lower-case until `\E` — `\U\1` shouts group 1 |
| `\=expr` | Replacement is Vimscript — `:%s/\d+/\=submatch(0)+1/` |
| `:g/pat/d` | Delete every matching line; `:v/pat/d` keeps only matches |
| `:g/pat/normal @q` | Run macro `q` on every matching line |
| `&` / `g&` | Repeat the last substitute on this line / whole file |

### ripgrep — `<leader>sg`, `<leader>sw`

Rust regex, not Vim's: `\b` not `\<`, and **no lookaround at all**.

| Pattern | Meaning |
| --- | --- |
| `\b` | Word boundary |
| `(?i)pat` | Case-insensitive from here on |
| `(?:...)` | Non-capturing group |
| `x\|y` | Alternation — plain, no backslash |
| `query -- *.tex` | fzf-lua: everything after a bare `--` becomes an `--iglob` **(custom)** |
| `query -- -tpy` | Same separator takes raw rg flags — `-t` type, `-F` literal, `-w` word |

Search is smart-case by default: lowercase matches anything, one capital makes
it case-sensitive.

### Lua patterns — for editing this config

Not regex. `%` is the escape, and there is no alternation.

| Pattern | Meaning |
| --- | --- |
| `%s` `%w` `%d` `%a` | Space / alphanumeric / digit / letter — capitals negate |
| `.-` | Non-greedy `.*` |
| `%b()` | Balanced pair, nesting included |
| `%(` `%)` `%.` `%%` | Literal `(` `)` `.` `%` |
| `^` `$` | Anchors — `string.gsub` has no `\|`, use two passes |

---

## Getting back

| Key | Action |
| --- | --- |
| `<C-o>` / `<C-i>` | Back / forward through jumps |
| `` `` `` | Back to where you jumped from |
| `` `. `` | Back to your last edit |

---

## Start with four

| Key | Why |
| --- | --- |
| `\lt` | The table of contents. Replaces scrolling a 1000-line manuscript. |
| `]]` | Next section. Faster than the TOC once you know roughly where you are going. |
| `cse` | Change an environment without retyping the `\begin`/`\end` pair. |
| `<leader>sg` | Grep. Finds anything the other three do not. |

---

## Known gaps

- **`\ll` does not compile.** `latexmk` is not installed, so vimtex cannot build
  or forward-search. Compilation happens via Overleaf and a GitHub Action.
- **`]r` is unverified interactively.** The binding is correct and calls the same
  function `<a-n>` used, but the jump itself was never exercised in a real
  terminal.

## Language tooling

| Language | LSP | Lint | Format |
| --- | --- | --- | --- |
| Python | basedpyright + ruff | ruff (LSP) | `ruff_format` |
| LaTeX | texlab | — | `tex-fmt`, on demand only |
| JS/TS | vtsls | eslint (project) | biome → prettier fallback |
| Julia | julials | julials | — |
| Markdown | marksman | *(disabled)* | prettier |

`markdownlint` is deliberately off: it produced 358 diagnostics on one repo, 336
of them `MD013/line-length`.
