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
      \   'method': 'NearestMethodOrFunction',
    \ },
\}

function! FileEncoding() abort
  if &filetype==?'defx'
    return ""
  endif
 return (&fenc!=#""?&fenc:&enc)
endfunction

function! NearestMethodOrFunction() abort
  let l:method = get(b:, 'vista_nearest_method_or_function', '')
  if l:method != ''
    let l:method = '[' . l:method . ']'
  else
    let l:method = "[]"
  endif
  return l:method
endfunction

autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

