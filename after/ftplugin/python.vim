nnoremap <silent> <leader>tp :call AbrirTerminal_python()<CR>

nnoremap <silent> <Leader>r ggVG"cy :silent call Correr()<CR>
nnoremap <silent> <Leader>c }V{"cy :silent call Correr()<CR>}
nnoremap <silent> <Leader>v V"cy :silent call Correr()<CR>hj

function! BuscarErrores(timer) 
  call sign_unplace('g1',{'buffer':t:terminal_bufer_number})
  call sign_place(1,'g1','buscando',t:terminal_bufer_number,{'lnum':line('w$',t:terminal_windows_id)})
  let hasta = nvim_buf_line_count(t:terminal_bufer_number) 
  if hasta == t:terminal_last_line
    return ''
  endif
  let t:lines = nvim_buf_get_lines(t:terminal_bufer_number,t:terminal_last_line, hasta,0) 
  let s = 0
  for line in t:lines
    let s = s + 1
    if line =~ 'Error'
       call sign_place(0,'','error',t:terminal_bufer_number,{'lnum':t:terminal_last_line + s})
        call sign_unplace('g1',{'buffer':t:terminal_bufer_number})
	let errores=1
    endif
    if line =='>>>' || line == '>>> '
       let t = s
       "echom t + t:terminal_last_line
    endif
  endfor
  if exists("t")
    call timer_pause(t:timer,1)
    call sign_unplace('g1',{'buffer':t:terminal_bufer_number})
    if exists("errores")
      call sign_place(1,'g1','error',t:terminal_bufer_number,{'lnum':t+ t:terminal_last_line})
    else
      call sign_place(1,'g1','finalizado',t:terminal_bufer_number,{'lnum':t+t:terminal_last_line})
    endif
  endif
endfunction

function! GuardarUltimaLinea()
  let t:terminal_last_line = line('.',t:terminal_windows_id)
  call timer_pause(t:timer,0)
endfunction

function! SalirTab()
   if exists("t:timer")
	call timer_pause(t:timer,1)
   endif
endfunction

function! EntrarTab()
   if exists("t:timer")
     call timer_pause(t:timer,0)
   endif
endfunction

autocmd TabLeave * call SalirTab()
autocmd TabEnter * call EntrarTab()

function! AbrirTerminal_python()
  execute "vnew term://cmd"
  highlight! link SignColumn LineNr
  let t:timer = timer_start(100, 'BuscarErrores',{'repeat':-1})
  call timer_pause(t:timer,1)
  execute 'autocmd WinClosed <buffer> call timer_stop(t:timer)'
  execute 'autocmd WinClosed <buffer> unlet t:timer'
  execute 'tnoremap <buffer><silent> <CR> <C-\><C-n>:call GuardarUltimaLinea()<CR>i<CR>'
  execute "sign define error text=>> texthl=ErrorMsg"
  execute "sign define buscando text=>> texthl=ModeMsg"
  execute "sign define finalizado text=>> texthl=LineNr"
  let t:terminal_windows_id = win_getid()
  let t:terminal_id = b:terminal_job_id
  let t:terminal_bufer_number = bufnr()
  setlocal nonumber
  setlocal norelativenumber
  setlocal signcolumn=yes:1
  setlocal statuscolumn=%s\  
  execute chansend(t:terminal_id,'python')
  execute chansend(t:terminal_id,"\r")
  let t:terminal_last_line=0
  wincmd p
endfunction

function! Correr()
  execute win_id2win(t:terminal_windows_id) "wincmd w"
  execute GuardarUltimaLinea()
  let @C = "\n\n"
  normal! "cp
  normal! G
  wincmd p
endfunction
