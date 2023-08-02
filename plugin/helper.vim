" vim terminal tools
" created by smj

" chekc compatible
if has('patch-8.1.1') == 0
    finish
endif

if !exists('g:terminal_key')
    let g:terminal_key = '<m-=>'
endif

let s:buffer_name = "term"
let s:shell = $SHELL
let g:terminal_open = 0

function TermToggle()
    if g:terminal_open == 0
        call TermOpen()
        let g:terminal_open == 1
    else
        call TermClose()
        let g:terminal_open == 0
    endif
endfunction

function OpenTermBuffer()
  if bufexists(s:buffer_name) == 0
    call term_start(s:shell,{'term_name' : s:buffer_name, 'term_finish' : 'close', 'hidden' : 0})
    call setbufvar(s:buffer_name,"&number",0)
    call CloseTermWindow()
  endif
endfunction

function CloseTermBuffer()
  if bufexists(s:buffer_name) == 1
    execute "bdelete! ".s:buffer_name
  endif
endfunction

function OpenTermWindow()
  if bufexists(s:buffer_name) == 1
    let g:window_list = win_findbuf(bufnr(s:buffer_name))
    if len(g:window_list) == 0
      10split
      execute "b ".s:buffer_name
      wincmd p
    endif
  else
    echoerr "no term buffers open"
  endif
endfunction

function CloseTermWindow()
  let g:window_list = win_findbuf(bufnr(s:buffer_name))
  let i = 0
  while i < len(g:window_list)
    call win_execute(g:window_list[i],'quit')
    let i += 1
  endwhile
endfunction

function! TermOpen()
  call OpenTermBuffer()
  call OpenTermWindow()
endfunction

function! TermClose()
  call CloseTermBuffer()
  call CloseTermWindow()
endfunction

if get(g:, 'terminal_default_mapping', 1)
    noremap <m-H> <c-w>h
    noremap <m-L> <c-w>l
    noremap <m-J> <c-w>j
    noremap <m-K> <c-w>k
    inoremap <m-H> <esc><c-w>h
    inoremap <m-L> <esc><c-w>l
    inoremap <m-J> <esc><c-w>j
    inoremap <m-K> <esc><c-w>k

    if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
        set termwinkey=<c-_>
        tnoremap <m-H> <c-_>h
        tnoremap <m-L> <c-_>l
        tnoremap <m-J> <c-_>j
        tnoremap <m-K> <c-_>k
        tnoremap <m-N> <c-_>p
        tnoremap <m-q> <c-\><c-n>
        tnoremap <m--> <c-_>"0
    endif

    let s:cmd = 'nnoremap <silent>'.(g:terminal_key). ' '
    exec s:cmd . ':call TermToggle()<cr>'

    let s:cmd = 'tnoremap <silent>'.(g:terminal_key). ' '
    exec s:cmd . '<c-\><c-n>:call TermToggle()<cr>'
endif

