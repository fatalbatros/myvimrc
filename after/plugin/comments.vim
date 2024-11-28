au FileType cairo setl commentstring=//%s

nnoremap <silent> <A-e> :<C-U>call Comentar_normal()<CR>
nnoremap <silent> <A-q> :<C-U>call Descomentar_normal()<CR>
vnoremap <silent> <A-e> :<C-U>call Comentar_visual()<CR>gv
vnoremap <silent> <A-q> :<C-U>call Descomentar_visual()<CR>gv


function! Comentar_normal() range
  let pos = getcurpos()
  let line = pos[1]
  execute line .. ',' .. (line + v:count) .. 's/^/' .. escape(split(&commentstring, '%s')[0],'/')
  let pos[2] = pos[2] + 1
  call setpos('.', pos)
endfunction 

function! Descomentar_normal() range
  let pos = getcurpos()
  let line = pos[1]
  try
    execute line .. ',' .. (line + v:count) .. 's/^ *\zs'.. escape(split(&commentstring, '%s')[0],'/') .. '//'
    let pos[2] = pos[2] - 1
    call setpos('.', pos)
  catch
  endtry
endfunction 


function! Comentar_visual()
  execute "'\<,'\>s/^/" .. escape(split(&commentstring, '%s')[0],'/') 
  execute ":nohlsearch"
endfunction 


function! Descomentar_visual()
  execute "'\<,'\>s/^ *\\zs" .. escape(split(&commentstring, '%s')[0],'/').. "//e"
  execute ":nohlsearch"
endfunction

