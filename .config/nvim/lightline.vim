let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
      \ 'left': [
                 \ ['mode', 'paste'],
                 \ ['gitbranch', 'readonly', 'relativepath', 'modified'],
                 \ ['method']
               \ ],
      \ 'right': [
                  \ ['indent', 'percent', 'lineinfo'],
                  \ ['filetype', 'fileencode'],
                \ ],
    \ },
  \ 'component_expand': {
      \ 'indent': 'SleuthIndicator',
      \ 'fileencode': 'FileEncoding',
    \ },
  \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
    \ },
\}

function! FileEncoding() abort
  if &filetype==?'defx'
    return ""
  endif
 return (&fenc!=#""?&fenc:&enc)
endfunction
