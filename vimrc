
" --- load THE plugin ---
filetype plugin on
packadd vim-fugitive

" --- colors --- 
syntax on
set termguicolors
colorscheme alba

" --- filetypes config ---
au filetype cairo setlocal commentstring=//%s

" --- buffer sanity ---
set hidden
set noswapfile

set ttimeoutlen=10
set scrolloff=6
set nowrap
set textwidth=0
"some syntax files force tetxtwidth when they are loaded. This is the counter
au syntax * setlocal textwidth=0

" -- tab behaviour --
set softtabstop=-1
set shiftwidth=4
set expandtab

" --- visual aid ---
set list
set showbreak=^\ 
"this is for autoset the aid when changing the amount of spaces in a tab with set sw=n
execute 'set listchars=tab:>\ ,trail:_,leadmultispace:│' .. repeat('\ ',&sw-1)
au optionset shiftwidth execute 'setlocal listchars=tab:>\ ,trail:_,leadmultispace:│' .. repeat('\ ',&sw-1)


" --- split config ---
set splitright
set fillchars+=vert:│

" completion and defaul K
set completeopt=menu,popup
set keywordprg=

" --- netrw setup ---
let g:netrw_banner=0
let g:netrw_altfile=1
let g:netrw_cursor=0


" --- search ---
set hlsearch
set incsearch
nnoremap <silent> <C-l> :noh<CR>


" --- quickfix ---
nmap <silent> ]q :copen<CR>
nmap <silent> [q :cclose<CR>
noremap <silent> [c :<C-U>execute v:count1.'cprev'<CR>
noremap <silent> ]c :<C-U>execute v:count1.'cnext'<CR>


" --- general ---
nmap <Space>t :tabnew 
nmap <silent> <Space>e <C-6>
noremap Y y$


" ---  clipboard ---
noremap <silent> <space>y "yy <Bar> :call system('xclip -selection "clipboard"', @y)<CR>
noremap <silent> <space>p :r!xclip -o<CR>


" --- windows resizing ---
noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Up> :resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>


" --- Indentation ---
"my terminal send <Esc> as ^[ and <Alt-x> as ^[x. This is for seting what <A-j> should look like
"read :help set-termcap for reference, you can check what the term send with sed -n l
set <A-j>=j
set <A-k>=k
set <A-h>=h
set <A-l>=l

nnoremap <silent> <A-j> :<C-U>execute 'm+'.v:count1<CR>
nnoremap <silent> <A-k> :<C-U>execute 'm-1-'.v:count1<CR>
vnoremap <silent> <A-j> :<C-U>execute "'\<,'\>m'>+".v:count1<CR>gv
vnoremap <silent> <A-k> :<C-U>execute "'\<,'\>m'<-1-".v:count1<CR>gv

noremap <silent> <A-l> >>
noremap <silent> <A-h> <<
vnoremap <silent> <A-l> :<C-U>execute "'\<,'\>>"<CR>gv
vnoremap <silent> <A-h> :<C-U>execute "'\<,'\><"<CR>gv


" --- Statusline --- (vim9)
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

" --- Tabline --- (vim9)
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

" --- coments ---
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


function s:filter_list(id, key)
  let result = getcurpos(a:id)[1]
  let filename = split(getbufline(winbufnr(a:id), result)[0])[-1]
  if a:key == ''
    execute(':buffer ' .. filename)
    call popup_close(a:id, 0)
  elseif a:key == 'p'
    execute(':buffer ' .. filename)
  elseif a:key == 't'
    execute(':tabnew ' .. filename)
    call popup_close(a:id, 0)
  elseif a:key == 's'
    execute(':vsplit ' .. filename)
    call popup_close(a:id, 0)
  elseif a:key == 'd'
    execute(':bdelete ' .. filename)
    call deletebufline(winbufnr(a:id), result)
  else 
    return popup_filter_menu(a:id, a:key)
  endif
  return v:true
endfunction

function s:pad_to_width(text, width, side)
  const pad = a:width - strwidth(a:text)
  if pad <= 0 | return a:text | endif
  if a:side == 'left'  | return repeat(' ', pad) .. a:text | endif
  return a:text .. repeat(' ', pad) 
endfunction

function s:LIST()
  let bufers = getbufinfo({'buflisted': 1, 'bufloaded': 1})
  let lista = []
  for bufer in bufers
    const bufnr = s:pad_to_width(string(bufer['bufnr']), 3, 'right')
    const line = s:pad_to_width(string(bufer['lnum']), 4, 'left')
    const lines = s:pad_to_width(string(bufer['linecount']), 4, 'right')
    const fname = bufer['name']
    const short = s:pad_to_width(fnamemodify(fname, ":t"), 25, 'right')
    const text = bufnr  .. "  "  ..  line .. "/" .. lines .. "   " .. short .. " "  .. fname
    call extend(lista, [text])
  endfor
  let options = {
    \'border': [1, 1, 1, 1],
    \'highlight': 'Normal',
    \'borderhighlight': ['LineNr'],
    \'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'], 
    \'callback': { -> ''},
    \'filter': 's:filter_list',
  \}
  call  popup_menu(lista, options)
endfunction

nnoremap <silent> <space>l :call <SID>LIST()<CR>

function s:filter_marks(id, key)
  let result = getcurpos(a:id)[1]
  let mark = split(getbufline(winbufnr(a:id), result)[0])[0]
  let filename = split(getbufline(winbufnr(a:id), result)[0])[-1]
  if a:key =~ '[A-Z]'
    execute("normal! `" .. a:key)
    call popup_close(a:id, 0)
  elseif a:key == ''
    execute("normal! `" .. mark)
    call popup_close(a:id, 0)
  elseif a:key == 'p'
    execute("normal! `" .. mark)
  elseif a:key == 't'
    execute(':tabnew ' .. filename)
    execute("normal! `" .. mark)
    call popup_close(a:id, 0)
  elseif a:key == 's'
    execute(':vsplit ' .. filename)
    execute("normal! `" .. mark)
    call popup_close(a:id, 0)
  elseif a:key == 'd'
    execute(':delmarks ' .. mark)
    call deletebufline(winbufnr(a:id), result)
  else
    return popup_filter_menu(a:id, a:key)
  endif
  return v:true
endfunction

function s:MARKS()
  let marks = getmarklist()
  let lista = []
  for mark in marks
    if match(mark['mark'], "[0-9]") != -1 | continue | endif
    let leter = mark['mark'][1]
    let line = s:pad_to_width(string(mark['pos'][1]), 5, 'left')
    let fname = mark['file']
    let short = s:pad_to_width(fnamemodify(fname, ":t"), 25, 'right')
    let text =  leter  .. "    " .. line  .. "    " .. short .. fname
    call extend(lista, [text])
  endfor
  let options = {
    \'border': [1, 1, 1, 1],
    \'highlight': 'Normal',
    \'borderhighlight': ['LineNr'],
    \'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'], 
    \'callback': { -> "" },
    \'filter': 's:filter_marks',
  \}
  call popup_menu(lista, options)
endfunction

nnoremap <silent> <space>m :call <SID>MARKS()<CR>

"------------TERMINAL----------------
tmap <Esc> <C-\><C-n>


"------------lsp----------------
source <sfile>:h/lsp/source.vim
