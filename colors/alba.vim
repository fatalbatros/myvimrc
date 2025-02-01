
"let @f = ':echo synIDattr(synIDtrans(synID(line("."), col("."), 1)),"fg")'
"let @g = ':echo synIDattr(synIDtrans(synID(line("."), col("."), 1)),"fg#")'
"let @v = ':echo synIDattr(synIDtrans(synID(line("."), col("."), 1)),"bg")'
"let @b = ':echo synIDattr(synIDtrans(synID(line("."), col("."), 1)),"bg#")'
"let @n = ':echo synIDattr(synIDtrans(synID(line("."), col("."), 1)),"name")'


" Colors used
" #0D0D0D -- FONDO
" #FFFFFF -- Blanco
" #DDDDDD -- Normal
" #8C8C8C -- Gris Fuerte
" #404040 -- Gris Debil
" #F2F2F2
" #D99962
" Naranja ff9e00

hi! Normal          ctermfg=White        ctermbg=Black    cterm=NONE    guifg=#DDDDDD    guibg=#0D0D0D    gui=NONE
hi! Highlight       ctermfg=White        ctermbg=Black    cterm=NONE    guifg=#FFFFFF    guibg=#0D0D0D    gui=NONE
hi! FadedLight      ctermfg=White        ctermbg=Black    cterm=NONE    guifg=#8C8C8C    guibg=#0D0D0D    gui=NONE
hi! FadedStrong     ctermfg=White        ctermbg=Black    cterm=NONE    guifg=#404040    guibg=#0D0D0D    gui=NONE
hi! Empty           ctermfg=White        ctermbg=Black    cterm=NONE    guifg=#0D0D0D    guibg=#0D0D0D    gui=NONE
hi! ErrorMsg        ctermfg=DarkGray     ctermbg=Black    cterm=NONE    guifg=#FF0000    guibg=#0D0D0D    gui=NONE
hi! WarningMsg      ctermfg=210          ctermbg=Black    cterm=NONE    guifg=#D99962    guibg=#0D0D0D    gui=NONE


" --------------------------------
" Editor settings
" --------------------------------
hi! link LineNr FadedStrong 
hi! link LineNrAbove FadedStrong
hi! link LineNrBelow FadedStrong 

" -----------------
" - Number column -
" -----------------
hi! link SignColumn FadedStrong
hi! ColorColumn guibg=#383838
hi! link Folded FadedStrong

"" -------------------------
"" - Window/Tab delimiters -
"" -------------------------
hi! link VertSplit FadedStrong
hi! link TabLine FadedStrong
hi! link TabLineFill Empty
hi! link TabLineSel Normal

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
"
hi! Directory       ctermfg=White        ctermbg=Black    cterm=Bold    guifg=#DDDDDD    guibg=#0D0D0D    gui=NONE
hi! link netrwPlain      FadedLight

hi! Search          ctermfg=White        ctermbg=210      cterm=NONE    guifg=#0D0D0D    guibg=#D99962    gui=NONE
hi! IncSearch       ctermfg=White        ctermbg=210      cterm=NONE    guifg=#0D0D0D    guibg=#D99962    gui=NONE

" -----------------
" - Prompt/Status -
" -----------------
hi! link StatusLine      Normal
hi! link StatusLineNC    Normal     
hi! link WildMenu        WarningMsg
hi! link Question        WarningMsg
hi! link Title           Normal
hi! link ModeMsg         Normal
hi! link MoreMsg         WarningMsg

" --------------
" - Visual aid -
" --------------
hi! link MatchParen      ErrorMsg
hi! Visual          ctermfg=White        ctermbg=DarkGray     cterm=NONE    guifg=#F2F2F2    guibg=#404040    gui=NONE
hi! link NonText FadedStrong

hi! link Todo            WarningMsg
hi! link Underlined      Normal
hi! link Error           ErrorMsg
hi! link Ignore          FadedStrong
hi! link SpecialKey      FadedStrong
hi! link WhiteSpaceChar  FadedStrong
hi! link WhiteSpace      FadedStrong

" --------------------------------
" Variable types
" --------------------------------
hi! link Constant        Normal
hi! link String          FadedLight
hi! link StringDelimiter Highlight
hi! link Character       Normal
hi! link Number          Normal
hi! link Float           Normal
hi! link Boolean         Highlight
"
hi! link Identifier      Highlight
hi! link Function        Highlight

"" --------------------------------
"" Language constructs
"" --------------------------------
hi! link Statement       Normal
hi! link Conditional     Highlight
hi! link Repeat          Normal
hi! link Label           Normal
hi! link Operator        Normal
hi! link Keyword         Normal
hi! link Exception       Normal
hi! link Comment         FadedLight
"
hi! link Special         Normal
hi! link SpecialChar     Normal
hi! link Tag             Normal
hi! link Delimiter       Normal
hi! link SpecialComment  FadedLight
hi! link Debug           Normal
"
"" ----------
"" - C like -
"" ----------
hi! link PreProc         Normal
hi! link Include         Normal
hi! link Define          Normal
hi! link Macro           Normal
hi! link PreCondit       Normal
"
hi! link Type            Normal
hi! link StorageClass    Normal
hi! link Structure       Normal
hi! link Typedef         Normal

" --------------------------------
" Diff
" --------------------------------
hi! DiffAdd         ctermfg=White    ctermbg=Black    cterm=NONE    guifg=#F2F2F2    guibg=#0D0D0D    gui=NONE
hi! DiffChange      ctermfg=White    ctermbg=Black    cterm=NONE    guifg=#F2F2F2    guibg=#0D0D0D    gui=NONE
hi! DiffDelete      ctermfg=White    ctermbg=Black    cterm=NONE    guifg=#F2F2F2    guibg=#0D0D0D    gui=NONE
hi! DiffText        ctermfg=White    ctermbg=Black    cterm=NONE    guifg=#F2F2F2    guibg=#0D0D0D    gui=NONE

" --------------------------------
" Completion menu
" --------------------------------
hi! Pmenu           ctermfg=Gray     ctermbg=Black    cterm=NONE    guifg=#0d0d0d    guibg=#404040    gui=NONE
hi! PmenuSel        ctermfg=Gray     ctermbg=Black    cterm=NONE    guifg=#8C8C8C    guibg=#404040    gui=NONE
hi! PmenuSbar       ctermfg=Gray     ctermbg=Black    cterm=NONE    guifg=#8C8C8C    guibg=#0D0D0D    gui=NONE
hi! PmenuThumb      ctermfg=Gray     ctermbg=Black    cterm=NONE    guifg=#8C8C8C    guibg=#0D0D0D    gui=NONE

