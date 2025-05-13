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
"some syntax files (vim) force tetxtwidth when they are loaded. This is the counter
au syntax vim setlocal textwidth=0 shiftwidth=2

" -- tab behaviour --
set softtabstop=-1
set shiftwidth=4
set expandtab
set autoindent

" --- visual aid ---
execute 'set listchars=tab:>\ ,leadmultispace:│' .. repeat('\ ',&sw-1)
"this is for autoset the aid when changing the amount of spaces in a tab with set sw=n
au optionset shiftwidth execute 'setlocal listchars=tab:>\ ,leadmultispace:│' .. repeat('\ ',&sw-1)
set list
set showbreak=^\ 


" --- split config ---
set splitright
set fillchars+=vert:\ 

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

def Statusline(): string
  if &buftype ==# ""
    return "%(%#Normal#[%L]%)%=%=%(%#Normal#%m (%n) %f%) "
  elseif &buftype ==# "help"
    return "%(%#Normal# %)%=%=%(%#NonText# [Help] %f%) "
  else
    return "%(%#Normal#%)%=%(%#NonText# (%n) %{&buftype}%) "
  endif
enddef


" --- Tabline --- (vim9)
set showtabline=2
set tabline=%!Tabline()

def Tabline(): string
  var s = ''
  for i in range(tabpagenr('$'))
    var tab = i + 1
    var winnr = tabpagewinnr(tab)
    var buflist = tabpagebuflist(tab)
    var bufnr = buflist[winnr - 1]
    var bufname = bufname(bufnr)
    var bufmodified = getbufvar(bufnr, "&mod")
    s = s .. '%' .. tab .. 'T'
    s = s .. (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    s = s .. ' ' .. tab .. ':'
    s = s .. (bufname != '' ? '[' .. fnamemodify(bufname, ':t') .. '] ' : '[No Name] ')
    if bufmodified
      s = s .. '[+] '
    endif
  endfor
  s = s .. '%#TabLineFill#'
  return s
enddef


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


def s:filter_list(id: number, key: string): bool
  const result = getcurpos(id)[1]
  const filename = split(getbufline(winbufnr(id), result)[0])[-1]
  if key == ''
    execute(':buffer ' .. filename)
    popup_close(id, 0)
  elseif key == 'p'
    execute(':buffer ' .. filename)
  elseif key == 't'
    execute(':tabnew ' .. filename)
    popup_close(id, 0)
  elseif key == 's'
    execute(':vsplit ' .. filename)
    popup_close(id, 0)
  elseif key == 'd'
    execute(':bdelete ' .. filename)
    deletebufline(winbufnr(id), result)
  else 
    return popup_filter_menu(id, key)
  endif
  return true
enddef

def s:pad_to_width(text: string, width: number, side: string): string
  const pad = width - strwidth(text)
  if pad <= 0 | return text | endif
  if side == 'left'  | return repeat(' ', pad) .. text | endif
  return text .. repeat(' ', pad) 
enddef

def s:LIST()
  const bufers = getbufinfo({buflisted: 1, bufloaded: 1})
  var lista = []
  for bufer in bufers
    const bufnr = s:pad_to_width(string(bufer['bufnr']), 3, 'right')
    const line = s:pad_to_width(string(bufer['lnum']), 4, 'left')
    const lines = s:pad_to_width(string(bufer['linecount']), 4, 'right')
    const fname = bufer['name']
    const short = s:pad_to_width(fnamemodify(fname, ":t"), 25, 'right')
    const text = bufnr  .. "  "  ..  line .. "/" .. lines .. "   " .. short .. " "  .. fname
    extend(lista, [text])
  endfor
  const options = {
    border: [1, 1, 1, 1],
    highlight: 'Normal',
    borderhighlight: ['LineNr'],
    borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'], 
    callback: (_, _) => '',
    filter: s:filter_list,
  }
  popup_menu(lista, options)
enddef

nnoremap <silent> <space>l :call <SID>LIST()<CR>

def s:filter_marks(id: number, key: string): bool
  const result = getcurpos(id)[1]
  const mark = split(getbufline(winbufnr(id), result)[0])[0]
  const filename = split(getbufline(winbufnr(id), result)[0])[-1]
  if key == ''
    execute("normal! `" .. mark)
    popup_close(id, 0)
  elseif key == 'p'
    execute("normal! `" .. mark)
  elseif key == 't'
    execute(':tabnew ' .. filename)
    execute("normal! `" .. mark)
    popup_close(id, 0)
  elseif key == 's'
    execute(':vsplit ' .. filename)
    execute("normal! `" .. mark)
    popup_close(id, 0)
  elseif key == 'd'
    execute(':delmarks ' .. mark)
    deletebufline(winbufnr(id), result)
  else
    return popup_filter_menu(id, key)
  endif
  return true
enddef

def s:MARKS()
  const marks = getmarklist()
  var lista = []
  for mark in marks
    if match(mark['mark'], "[0-9]") != -1 | continue | endif
    const leter = mark['mark'][-1]
    const line = s:pad_to_width(string(mark['pos'][1]), 5, 'left')
    const fname = mark['file']
    const short = s:pad_to_width(fnamemodify(fname, ":t"), 25, 'right')
    var text = leter  .. "    " .. line  .. "    " .. short .. fname
    extend(lista, [text])
  endfor
  const options = {
    border: [1, 1, 1, 1],
    highlight: 'Normal',
    borderhighlight: ['LineNr'],
    borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'], 
    callback: (_, _) => '',
    filter: s:filter_marks,
  }
  popup_menu(lista, options)
enddef

nnoremap <silent> <space>m :call <SID>MARKS()<CR>

"------------TERMINAL----------------
tmap <Esc> <C-\><C-n>


"------------lsp----------------
source <sfile>:h/lsp/source.vim
