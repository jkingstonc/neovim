set number
set relativenumber
set mouse=a
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4

call plug#begin()

" this is for the cool status bar at the bottom
Plug 'https://github.com/vim-airline/vim-airline'
" this is for the file explorer on the left
Plug 'https://github.com/preservim/nerdtree'

" this is for command auto completion
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" These are for the language servers etc
Plug 'https://github.com/williamboman/mason.nvim'
Plug 'https://github.com/williamboman/mason-lspconfig.nvim'
Plug 'https://www.github.com/neovim/nvim-lspconfig'
Plug 'https://www.github.com/simrat39/rust-tools.nvim'
" These are for auto completion in code (https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)
Plug 'https://www.github.com/hrsh7th/cmp-buffer'
Plug 'https://www.github.com/hrsh7th/cmp-nvim-lsp'
Plug 'https://www.github.com/hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'https://www.github.com/hrsh7th/cmp-nvim-lua'
Plug 'https://www.github.com/hrsh7th/cmp-path'
Plug 'https://www.github.com/hrsh7th/cmp-vsnip'
Plug 'https://www.github.com/hrsh7th/nvim-cmp'
Plug 'https://www.github.com/hrsh7th/vim-vsnip'

call plug#end()

call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('renderer', wilder#wildmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ }))

lua << EOF
require("mason").setup()
EOF

lua << EOF
-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})
EOF

nnoremap <C-t> :NERDTreeToggle<CR>
