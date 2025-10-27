" Quickfix action
function! s:build_quickfix_list(lines)
  let qf_list = []
  for line in a:lines
    let parts = matchlist(line, '\v^(.+):(\d+):(\d+):(.*)$')
    if len(parts) >= 5
      call add(qf_list, {
        \ 'filename': parts[1],
        \ 'lnum': parts[2],
        \ 'col': parts[3],
        \ 'text': parts[4] })
    else
      call add(qf_list, { 'filename': line })
    endif
  endfor
  call setqflist(qf_list)
  copen
endfunction

" Actions
let g:fzf_buffers_jump = 1
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Layout
let g:fzf_layout = { 'up': '~40%' }

" Colors
let g:fzf_colors = {
\ 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'] }

" History directory
let g:fzf_history_dir = '~/.local/share/fzf-history'

" RG with live reload
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
