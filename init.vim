"set notermguicolors
set noswapfile
set scrolloff=7
set smartcase
set softtabstop=4
set shiftwidth=4
set expandtab
set listchars=tab:>\ ,leadmultispace:\|\ \ \ ,trail:\ ,lead:\ 
set list
set splitright
syntax on
set completeopt=menu,menuone,preview


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
set statusline=%(%#NonText#cmd\ %S%)%=%=%15(%l\ [%L]\ %p%%%)
"--------------------------------------------------------
set splitright
let g:netrw_banner=0
let g:netrw_browse_Split=0

"------------------ plugin ---------------------
call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-fugitive'
call plug#end()
"-----------------------------------------------

highlight! link SignColumn NonText
highlight! link LineNrAbove NonText
highlight! link LineNr Normal
highlight! link LineNrBelow NonText
highlight! link Folded NonText
highlight! link WinSeparator NonText
"highlight! link WinSeparator TabLineFill
highlight! link FloatBorder WinSeparator
highlight! link NormalFloat Normal

nmap <silent> ]q :copen<CR>
nmap <silent> [q :cclose<CR>

nmap <silent> <Space>t :Texplore<CR>
nmap <silent> <Space>e :Rexplore<CR>

noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Up> :resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>
"--------------------------------quickfix------------------
au FileType qf setl nornu
noremap <silent> [c :<C-U>execute v:count1.'cprev'<CR>
noremap <silent> ]c :<C-U>execute v:count1.'cnext'<CR>
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
"------------------------- COPY----------------------------
noremap <space>y "+y
noremap <space>p "+p
"------------------------- FUNCIONES----------------------------
noremap <leader>y "+y

function! Winbar()
  let s = ""
  if &buftype==#""
    let s = "%(%#NonText#[%L]%)%=%=%(%#Normal#%m (%n) %f%)"
  elseif &buftype==#"help"
    let s = "%(%#NonText# %)%=%=%(%#NonText# [Help] %f%)"
  else
    let s = "%(%#NonText#%)%=%(%#NonText# (%n) %{&buftype}%)"
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
  execute "vnew term://bash"
  setlocal nonumber
  setlocal norelativenumber
  setlocal statuscolumn=%s\  
  au WinClosed <buffer> bd!
  normal i
endfunction

au FileType vim setl softtabstop=2 shiftwidth=2 listchars=leadmultispace:\|\ 

