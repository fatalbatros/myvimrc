set noswapfile
set number
set relativenumber
set scrolloff=7
set smartcase
set list
"--------------------------------- TEMP
"-------------------------------- VENTANAS ------------------------
set splitright
let g:netrw_banner=0
let g:netrw_browse_Split=0

nmap <silent> <Space>t :Texplore<CR>
nmap <silent> <Space>e :Rexplore<CR>
nmap <silent> <Space>od :call AbrirDirectorio()<CR>

noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Up> :resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>


"-------------------------------- INTEGRACION CON PYTHON -----------
set path =,,C:\Users\joel\AppData\Local\Programs\Python\Python311\**
let g:python3_host_prog = 'C:\Users\joel\AppData\Local\Programs\Python\Python311\python.exe'


tmap <Esc> <C-\><C-n>
nnoremap <silent> <leader>tp :call AbrirTerminal()<CR>
nnoremap <silent> <leader>tt :call AbrirTerminal_cmd()<CR>
nnoremap <silent> <Leader>r ggVG"cy :silent call Correr()<CR>
nnoremap <silent> <Leader>c }V{"cy :silent call Correr()<CR>}
nnoremap <silent> <Leader>v V"cy :silent call Correr()<CR>hj
"--------------------------------------------------------------------

"-------------------------- SATUS LINES----------------------------
set showtabline=2
set tabline=%!Tabline()
set winbar=%{%Winbar()%}

set laststatus=3
set cmdheight=1
set showcmd
set showcmdloc=statusline
set statusline=%(%#LineNr#cmd\ %S%)%=%=%15(%l\ [%L]\ %p%%%)
"--------------------PLUGINS-------------------------------------------
call plug#begin()
Plug 'rebelot/kanagawa.nvim'
"Plug 'kvrohit/rasmus.nvim'
call plug#end()
"---------------------------------------------------------------------

"------------------- COLORES------------------------------------------
colorscheme kanagawa-wave
"colorscheme rasmus
highlight! link SignColumn NonText
highlight! link LineNr NonText

nnoremap <silent> <A-j> :<C-U>execute 'm+'.v:count1<CR>
nnoremap <silent> <A-k> :<C-U>execute 'm-1-'.v:count1<CR>
vnoremap <silent><A-j> :<C-U>execute "'\<,'\>m'>+".v:count1<CR>gv
vnoremap <silent><A-k> :<C-U>execute "'\<,'\>m'<-1-".v:count1<CR>gv

noremap <A-l> >>
noremap <A-h> <<
vnoremap <silent> <A-l> :<C-U>execute "'\<,'\>>"<CR>gv
vnoremap <silent> <A-h> :<C-U>execute "'\<,'\><"<CR>gv

syntax on

"------------------------- FUNCIONES----------------------------
function! Winbar()
  let s = ""
  if &buftype==#""
    let s = " %(%#LineNr#[%L]%)%=%=%(%#LineNr#%m (%n) %f%)"
  elseif &buftype==#"help"
    let s = " %=%=%(%#LineNr# [Help] %f%)"
  else
    let s = "%=%(%#LineNr# %{&buftype}%)"
  endif
  return s
endfunction

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")
    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')
    if bufmodified
      let s .= '[+] '
    endif
  endfor
  let s .= '%#TabLineFill#'
  return s
endfunction

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

function! AbrirTerminal_cmd()
  execute "vnew term://cmd"
  highlight! link SignColumn LineNr
  setlocal nonumber
  setlocal norelativenumber
  setlocal signcolumn=yes:1
  setlocal statuscolumn=%s\  
  wincmd p
endfunction

function! AbrirTerminal()
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
  let @C = ''
  normal! "cp
  normal! G
  wincmd p
endfunction

function! AbrirDirectorio()
  if &buftype=='terminal'
    echom "No se puede abrir el directorio de una terminal"
  elseif has('win32')
    let path = substitute(expand('%:p:h'),'/','\\','g')
    if path != ""
      silent execute '!explorer.exe '.path
    else
      let path = substitute(b:netrw_curdir, '/','\\','g')
      silent execute '!explorer.exe '.path
    endif
  else
    echom "Joel solamente lo implemento para windows"
  endif
endfunction

