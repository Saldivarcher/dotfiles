call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
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
call plug#end()

set t_Co=256
set nocompatible

set encoding=UTF-8

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

filetype plugin on
filetype indent on

set autoread
set nobackup
set nowb
set noswapfile

set whichwrap+=<,>,h,l
" Highlight matching bracket
set showmatch
set mat=2
set hidden
" Make vim command bar a bit bigger
set cmdheight=2
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
nnoremap <leader>rs :ReloadSleuth<CR>
" Go back to previous open file
nnoremap <leader>gb :e#<CR>
" Show buffers in fzf
nnoremap <leader>sb :Buffers<CR>
" Show marks in fzf
nnoremap <leader>sm :Marks<CR>
" Closes all but the current buffer
nnoremap <leader>bo :BufOnly<CR>
" Opens a new terminal in a newtab
nnoremap <leader>tt :tabnew<CR>:terminal<CR>
nnoremap <leader>ot :terminal<CR>

" close a quickfix window
nnoremap <leader>cw :ccl<CR>

" Unhighlights search results
nnoremap <leader><space> :noh<cr>
nnoremap <leader>dw :TrimWhitespace<cr>
nnoremap <F7> :Dispatch!<CR>
nnoremap <leader>rg :RG<CR>

function! Formatonsave()
  " Only format the diff.
  let l:formatdiff = 1
  py3f ~/.local/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp,*.c call Formatonsave()

" Spell check
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown  setlocal spell
autocmd FileType vimwiki  setlocal spell
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.automatic_nested_syntaxes = 1
let g:vimwiki_list = [wiki]
let g:vimwiki_folding='syntax'

source  ~/.config/nvim/fzf.vim
luafile ~/.config/nvim/lua/lsp.lua
luafile ~/.config/nvim/lua/context.lua
luafile ~/.config/nvim/lua/tab.lua
luafile ~/.config/nvim/lua/colorscheme.lua
