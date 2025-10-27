call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'jremmen/vim-ripgrep'
Plug 'justinmk/vim-syntax-extra'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-sleuth'
Plug 'airblade/vim-gitgutter'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'zbirenbaum/copilot-cmp'
Plug 'hrsh7th/nvim-cmp'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/vim-llvm'
Plug 'vim-scripts/BufOnly.vim'
Plug 'dag/vim-fish'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-dispatch'
Plug 'chrisbra/NrrwRgn'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-obsession'
"Plug 'liuchengxu/vista.vim'
Plug 'folke/flash.nvim'
Plug 'ggandor/leap.nvim'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp CC=gcc-12'} " Replace <CurrentMajor> by the latest released major (first number of latest release)
Plug 'CopilotC-Nvim/CopilotChat.nvim', {'branch': 'main'}
Plug 'nvim-lua/plenary.nvim'
Plug 'zbirenbaum/copilot.lua'
Plug 'onsails/lspkind.nvim'
Plug 'rust-lang/rust.vim'
"Plug 'github/copilot.vim'
call plug#end()

set termguicolors

syntax on
set number
set ruler

if get(g:, '_has_set_default_indent_settings', 0) == 0
  " Set the indenting level to 2 spaces for the following file types.
  autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml
        \ setlocal expandtab tabstop=2 shiftwidth=2
  let g:_has_set_default_indent_settings = 1
endif

"set wrap
"set textwidth=79

set mouse=a
set ffs=unix,dos,mac
set updatetime=300

filetype plugin indent on

set autoread
set nobackup
set nowb
set noswapfile

set whichwrap+=<,>,h,l
" Highlight matching bracket
set showmatch
set mat=2
set hidden
set shortmess+=c

" Blinking cursor, although doesn't have an effect on alacritty
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" Lowers brightness on matching brackets
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
"autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'nvim_lsp'

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['up:50%:wrap']

command! TrimWhitespace call TrimWhitespace()

" If in insert mode, help cannot be called
inoremap <F1> <Esc>
noremap <F1> :call MapF1()<CR>

let mapleader=' '

nnoremap <leader>nt :tabnew<CR>
nnoremap <leader>bt :-tabnew<CR>
nnoremap <leader>hh :tabprevious<CR>
nnoremap <leader>ll :tabnext<CR>
nnoremap <leader>vs :vsplit<CR>
" Closes preview window
nnoremap <leader>cp :pc<CR>
nnoremap <leader>cg :ChangeToGnu<CR>
nnoremap <leader>cj :clearjumps<CR>
nnoremap <leader>rr :FZF<CR>
nnoremap <leader>bs :set scrollback=1<CR>
nnoremap <leader>bd :set scrollback=100000<CR>
nnoremap <leader>rs :Sleuth<CR>
" Go back to previous open file
nnoremap <leader>gb :e#<CR>
" Show buffers in fzf
nnoremap <leader>sb :Buffers<CR>
" Show marks in fzf
nnoremap <leader>sm :Marks<CR>
" Closes all but the current buffer
nnoremap <leader>db :BufOnly<CR>
" Opens a new terminal in a newtab
nnoremap <leader>tt :tabnew<CR>:terminal<CR>
nnoremap <leader>ot :terminal<CR>

" close a quickfix window
nnoremap <leader>cw :ccl<CR>
nnoremap <leader>ts :TSContext toggle<CR>

" Unhighlights search results
nnoremap <leader><space> :noh<cr>
nnoremap <leader>dw :TrimWhitespace<cr>
nnoremap <F7> :Dispatch!<CR>
nnoremap <F8> :Vista finder<CR>
nnoremap <leader>rg :RG<CR>

let g:RunClangFormat = 1
function! Formatonsave()
  " Only format the diff.
  let l:formatdiff = 1
  if g:RunClangFormat
    if !empty(expand(glob("/usr/share/clang/clang-format.py")))
      py3f /usr/share/clang/clang-format.py
    else
      py3f ~/.local/share/clang/clang-format.py
    endif
  endif
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp,*.c call Formatonsave()

autocmd BufWritePre *.rs RustFmt

" Spell check
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown  setlocal spell
autocmd FileType vimwiki  setlocal spell
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

let fortran_have_tabs=1

source  ~/.config/nvim/fzf.vim
luafile ~/.config/nvim/lua/my-fzf.lua
luafile ~/.config/nvim/lua/lsp.lua
luafile ~/.config/nvim/lua/context.lua
luafile ~/.config/nvim/lua/tab.lua
luafile ~/.config/nvim/lua/colorscheme.lua
luafile ~/.config/nvim/lua/motion.lua
luafile ~/.config/nvim/lua/my-copilot.lua
