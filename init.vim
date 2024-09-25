set noswapfile
set filetype
set scrolloff=7
set smartcase
set softtabstop=4
set shiftwidth=4
set expandtab
set listchars=tab:>\ ,leadmultispace:\|\ \ \ ,trail:\ ,lead:\ 
set list
syntax on

"--------------------- info en los bordes ------------
set number
set relativenumber
set showtabline=2
set tabline=%!Tabline()
set winbar=%{%Winbar()%}
set laststatus=3
set cmdheight=1
set showcmd
set showcmdloc=statusline
set statusline=%(%#LineNr#cmd\ %S%)%=%=%15(%l\ [%L]\ %p%%%)
"--------------------------------------------------------

set splitright
let g:netrw_banner=0
let g:netrw_browse_Split=0

"------------------ plugin ---------------------
call plug#begin()
Plug 'rebelot/kanagawa.nvim'
call plug#end()
"-----------------------------------------------
colorscheme kanagawa-wave
highlight! link SignColumn NonText
highlight! link LineNr NonText
highlight! link Folded NonText

nmap <silent> <Space>t :Texplore<CR>
nmap <silent> <Space>e :Rexplore<CR>
nmap <silent> <Space>od :call AbrirDirectorio()<CR>

noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Up> :resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>
"--------------------------------quickfix------------------
au FileType qf setl nornu
noremap <silent> [q :<C-U>execute v:count1.'cprev'<CR>
noremap <silent> ]q :<C-U>execute v:count1.'cnext'<CR>
noremap <silent> [l :<C-U>execute v:count1.'lprev'<CR>
noremap <silent> ]l :<C-U>execute v:count1.'lnext'<CR>

"-------------------------------- INTEGRACION CON PYTHON -----------
tmap <Esc> <C-\><C-n>
nnoremap <silent> <leader>tt :call OpenTerminal()<CR>


"--------------------- Indentacion--------------------
nnoremap <silent> <A-j> :<C-U>execute 'm+'.v:count1<CR>
nnoremap <silent> <A-k> :<C-U>execute 'm-1-'.v:count1<CR>
vnoremap <silent><A-j> :<C-U>execute "'\<,'\>m'>+".v:count1<CR>gv
vnoremap <silent><A-k> :<C-U>execute "'\<,'\>m'<-1-".v:count1<CR>gv

noremap <A-l> >>
noremap <A-h> <<
vnoremap <silent> <A-l> :<C-U>execute "'\<,'\>>"<CR>gv
vnoremap <silent> <A-h> :<C-U>execute "'\<,'\><"<CR>gv
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

function! OpenTerminal()
  execute "vnew term://cmd"
  highlight! link SignColumn LineNr
  setlocal nonumber
  setlocal norelativenumber
  setlocal statuscolumn=%s\  
  normal i
endfunction

" Esto no merece estar en ftplugin todavia
au FileType tex setl softtabstop=2 shiftwidth=2 listchars=leadmultispace:\|\  
au FileType vim setl softtabstop=2 shiftwidth=2 listchars=leadmultispace:\|\ 
au FileType cairo setl commentstring=//%s
