set ttimeoutlen=10
set termguicolors
set hidden
set noswapfile
set scrolloff=5
set smartcase
set softtabstop=2
set shiftwidth=2
set expandtab
set listchars=tab:>\ ,leadmultispace:\|\ ,trail:\ ,lead:\ 
set list
set showbreak=+++\ 
set splitright
filetype plugin on
set completeopt=menu,popup
syntax on
set keywordprg=
let g:netrw_banner=0
let g:netrw_browse_Split=0

"----------------- search ----------
set hlsearch
set incsearch
nnoremap <silent> <C-l> :noh<CR>
"----------------------------------
"
"-------quickfix---------------------------
nmap <silent> ]q :copen<CR>
nmap <silent> [q :cclose<CR>
noremap <silent> [c :<C-U>execute v:count1.'cprev'<CR>
noremap <silent> ]c :<C-U>execute v:count1.'cnext'<CR>
"-----------------------------------------

"-----------------general---------------------------
nmap <Space>t :tabnew 
nmap <silent> <Space>e :Rexplore<CR>
noremap Y y$
"----------------------------------------------------


"----------------- clipboard ---------------------------
noremap <silent> <space>y "yy <Bar> :call system('xclip -selection "clipboard"', @y)<CR>
noremap <silent> <space>p :r!xclip -o<CR>

"-------------windows resizing----------------------
noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Up> :resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>
"----------------------------------------------------

"call plug#begin()
"    let g:lsp_auto_enable = 0
"    Plug 'prabirshrestha/vim-lsp', {'for':['rust','typescript','cairo']}
"    Plug 'tpope/vim-fugitive'
"call plug#end()

colorscheme based

"--------------------- Indentacion--------------------
"my terminal send <Esc> as ^[ and <Alt-x> as ^[x. This is for seting what <A-j> should look like
"read :help set-termcap for reference, you can check what the term send with sed -n l
set <A-j>=j
set <A-k>=k
set <A-h>=h
set <A-l>=l

nnoremap <silent><A-j> :<C-U>execute 'm+'.v:count1<CR>
nnoremap <silent><A-k> :<C-U>execute 'm-1-'.v:count1<CR>
vnoremap <silent><A-j> :<C-U>execute "'\<,'\>m'>+".v:count1<CR>gv
vnoremap <silent><A-k> :<C-U>execute "'\<,'\>m'<-1-".v:count1<CR>gv

noremap <A-l> >>
noremap <A-h> <<
vnoremap <silent> <A-l> :<C-U>execute "'\<,'\>>"<CR>gv
vnoremap <silent> <A-h> :<C-U>execute "'\<,'\><"<CR>gv
"------------------------------------------------------------------


"----------------Statusline--------------------------
set statusline=%{%Statusline()%}
set laststatus=2
set cmdheight=1
set showcmd
set showcmdloc=last

function! Statusline()
  let s = ""
  if &buftype==#""
    let s = "%(%#Normal#[%L]%)%=%=%(%#Normal#%m (%n) %f%) "
  elseif &buftype==#"help"
    let s = "%(%#Normal# %)%=%=%(%#NonText# [Help] %f%) "
  else
    let s = "%(%#Normal#%)%=%(%#NonText# (%n) %{&buftype}%) "
  endif
  return s
endfunction
"--------------------------------------------------------------

"--------------------------Tabline--------------------------------
set showtabline=2
set tabline=%!Tabline()

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
"--------------------------------------------------------------

"---------------------coments----------------------------------
"my terminal send <Esc> as ^[ and <Alt-x> as ^[x. This is for seting what <A-x> should look like
"read :help set-termcap for reference, you can check what the term send with sed -n l
set <A-e>=e
set <A-q>=q

nnoremap <silent> <A-e> :<C-U>call <SID>Comentar_normal()<CR>
nnoremap <silent> <A-q> :<C-U>call <SID>Descomentar_normal()<CR>
vnoremap <silent> <A-e> :<C-U>call <SID>Comentar_visual()<CR>gv
vnoremap <silent> <A-q> :<C-U>call <SID>Descomentar_visual()<CR>gv

function! s:Comentar_normal() range
  let pos = getcurpos()
  let line = pos[1]
  execute line .. ',' .. (line + v:count) .. 's/^/' .. escape(split(&commentstring, '%s')[0],'/')
  let pos[2] = pos[2] + 1
  call setpos('.', pos)
endfunction 

function! s:Descomentar_normal() range
  let pos = getcurpos()
  let line = pos[1]
  try
    execute line .. ',' .. (line + v:count) .. 's/^ *\zs'.. escape(split(&commentstring, '%s')[0],'/') .. '//'
    let pos[2] = pos[2] - 1
    call setpos('.', pos)
  catch
  endtry
endfunction 

function! s:Comentar_visual()
  execute "'\<,'\>s/^/" .. escape(split(&commentstring, '%s')[0],'/') 
  execute ":nohlsearch"
endfunction 


function! s:Descomentar_visual()
  execute "'\<,'\>s/^ *\\zs" .. escape(split(&commentstring, '%s')[0],'/').. "//e"
  execute ":nohlsearch"
endfunction
"--------------------------------------------------

"------------TERMINAL----------------
tmap <Esc> <C-\><C-n>
"----------------------------------------------------------
"
"------------lsp----------------
source <sfile>:h/lsp/source.vim
"----------------------------------------------------------
