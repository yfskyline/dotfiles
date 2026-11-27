" Skyline: original cterm colors converted to fixed RGB values.
" Source after colorscheme default and existing highlight settings.
" No runtime conversion, JSON or plugin dependency.
" Existing cterm definitions and links remain untouched.
" Unspecified cterm colors stay NONE, preserving terminal defaults.
" ANSI 0-15: captured Terminal.app palette; 16-255: standard xterm palette.
" This file does not enable termguicolors by itself.

" Base Vim highlight groups
highlight SpecialKey             guifg=#5fd7ff guibg=NONE gui=NONE guisp=NONE
highlight NonText                guifg=#0000ff guibg=NONE gui=NONE guisp=NONE
highlight Directory              guifg=#afffff guibg=NONE gui=NONE guisp=NONE
highlight ErrorMsg               guifg=#e6e6e6 guibg=#990000 gui=NONE guisp=NONE
highlight IncSearch              guifg=NONE guibg=NONE gui=reverse guisp=NONE
highlight Search                 guifg=#000000 guibg=#e6e600 gui=NONE guisp=NONE
highlight MoreMsg                guifg=#87ffaf guibg=NONE gui=NONE guisp=NONE
highlight ModeMsg                guifg=NONE guibg=NONE gui=bold guisp=NONE
highlight LineNr                 guifg=#e6e600 guibg=NONE gui=NONE guisp=NONE
highlight CursorLineNr           guifg=#e6e600 guibg=NONE gui=underline guisp=NONE
highlight Question               guifg=#87ffaf guibg=NONE gui=NONE guisp=NONE
highlight StatusLine             guifg=NONE guibg=NONE gui=bold,reverse guisp=NONE
highlight StatusLineNC           guifg=NONE guibg=NONE gui=reverse guisp=NONE
highlight VertSplit              guifg=NONE guibg=NONE gui=reverse guisp=NONE
highlight Title                  guifg=#ffd7ff guibg=NONE gui=NONE guisp=NONE
highlight Visual                 guifg=#000000 guibg=#a8a8a8 gui=NONE guisp=NONE
highlight VisualNOS              guifg=NONE guibg=NONE gui=bold,underline guisp=NONE
highlight WarningMsg             guifg=#ffd7d7 guibg=NONE gui=NONE guisp=NONE
highlight WildMenu               guifg=#000000 guibg=#e6e600 gui=NONE guisp=NONE
highlight Folded                 guifg=#00e6e6 guibg=#6c6c6c gui=NONE guisp=NONE
highlight FoldColumn             guifg=#00e6e6 guibg=#6c6c6c gui=NONE guisp=NONE
highlight DiffAdd                guifg=NONE guibg=#0000b3 gui=NONE guisp=NONE
highlight DiffChange             guifg=NONE guibg=#b300b3 gui=NONE guisp=NONE
highlight DiffDelete             guifg=#0000ff guibg=#00a6b3 gui=NONE guisp=NONE
highlight DiffText               guifg=NONE guibg=#e60000 gui=bold guisp=NONE
highlight SignColumn cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
highlight Conceal                guifg=#bfbfbf guibg=#6c6c6c gui=NONE guisp=NONE
highlight SpellBad               guifg=NONE guibg=#e60000 gui=NONE guisp=NONE
highlight SpellCap               guifg=NONE guibg=#0000ff gui=NONE guisp=NONE
highlight SpellRare              guifg=NONE guibg=#e600e6 gui=NONE guisp=NONE
highlight SpellLocal             guifg=NONE guibg=#00e6e6 gui=NONE guisp=NONE
highlight Pmenu                  guifg=#000000 guibg=#e600e6 gui=NONE guisp=NONE
highlight PmenuSel               guifg=#6c6c6c guibg=#000000 gui=NONE guisp=NONE
highlight PmenuSbar              guifg=NONE guibg=#a8a8a8 gui=NONE guisp=NONE
highlight PmenuThumb             guifg=NONE guibg=#e6e6e6 gui=NONE guisp=NONE
highlight TabLine                guifg=#e6e6e6 guibg=#6c6c6c gui=underline guisp=NONE
highlight TabLineSel             guifg=NONE guibg=NONE gui=bold guisp=NONE
highlight TabLineFill            guifg=NONE guibg=NONE gui=reverse guisp=NONE
highlight CursorColumn           guifg=NONE guibg=#6c6c6c gui=NONE guisp=NONE
highlight CursorLine             guifg=NONE guibg=NONE gui=underline guisp=NONE
highlight ColorColumn            guifg=NONE guibg=#990000 gui=NONE guisp=NONE
highlight StatusLineTerm         guifg=#000000 guibg=#87ffaf gui=bold guisp=NONE
highlight StatusLineTermNC       guifg=#000000 guibg=#87ffaf gui=NONE guisp=NONE
highlight Added                  guifg=#00d900 guibg=NONE gui=NONE guisp=NONE
highlight MatchParen             guifg=NONE guibg=#00a6b3 gui=NONE guisp=NONE
highlight ToolbarLine            guifg=NONE guibg=#6c6c6c gui=NONE guisp=NONE
highlight ToolbarButton          guifg=#000000 guibg=#bfbfbf gui=bold guisp=NONE
highlight Comment                guifg=#00e6e6 guibg=NONE gui=NONE guisp=NONE
highlight Constant               guifg=#e600e6 guibg=NONE gui=NONE guisp=NONE
highlight Special                guifg=#ffd7d7 guibg=NONE gui=NONE guisp=NONE
highlight Identifier             guifg=#00e6e6 guibg=NONE gui=bold guisp=NONE
highlight Statement              guifg=#e6e600 guibg=NONE gui=NONE guisp=NONE
highlight PreProc                guifg=#5fd7ff guibg=NONE gui=NONE guisp=NONE
highlight Type                   guifg=#87ffaf guibg=NONE gui=NONE guisp=NONE
highlight Underlined             guifg=#5fd7ff guibg=NONE gui=underline guisp=NONE
highlight Ignore                 guifg=#000000 guibg=NONE gui=NONE guisp=NONE
highlight Changed                guifg=#0000ff guibg=NONE gui=NONE guisp=NONE
highlight Removed                guifg=#e60000 guibg=NONE gui=NONE guisp=NONE
highlight Error                  guifg=#e6e6e6 guibg=#e60000 gui=NONE guisp=NONE
highlight Todo                   guifg=#000000 guibg=#e6e600 gui=NONE guisp=NONE
highlight Bold                   guifg=NONE guibg=NONE gui=bold guisp=NONE
highlight Italic                 guifg=NONE guibg=NONE gui=italic guisp=NONE
highlight BoldItalic             guifg=NONE guibg=NONE gui=bold,italic guisp=NONE

" vim-airline snapshot (plugins may overwrite these on mode changes)
highlight airline_x              guifg=#ffffff guibg=#121212 gui=NONE guisp=NONE
highlight airline_x_bold         guifg=#ffffff guibg=#121212 gui=bold guisp=NONE
highlight airline_x_red          guifg=#d70000 guibg=#121212 gui=NONE guisp=NONE
highlight airline_y              guifg=#9e9e9e guibg=#303030 gui=NONE guisp=NONE
highlight airline_y_bold         guifg=#9e9e9e guibg=#303030 gui=bold guisp=NONE
highlight airline_y_red          guifg=#d70000 guibg=#303030 gui=NONE guisp=NONE
highlight airline_z              guifg=#005f00 guibg=#afd700 gui=NONE guisp=NONE
highlight airline_z_bold         guifg=#005f00 guibg=#afd700 gui=bold guisp=NONE
highlight airline_z_red          guifg=#d70000 guibg=#afd700 gui=NONE guisp=NONE
highlight airline_term           guifg=#5fffaf guibg=#080808 gui=NONE guisp=NONE
highlight airline_term_bold      guifg=#5fffaf guibg=#080808 gui=bold guisp=NONE
highlight airline_term_red       guifg=#d70000 guibg=#080808 gui=NONE guisp=NONE
highlight airline_error          guifg=#080808 guibg=#d70000 gui=NONE guisp=NONE
highlight airline_error_bold     guifg=#080808 guibg=#d70000 gui=bold guisp=NONE
highlight airline_error_red      guifg=#d70000 guibg=#d70000 gui=NONE guisp=NONE
highlight airline_a              guifg=#005f00 guibg=#afd700 gui=NONE guisp=NONE
highlight airline_a_bold         guifg=#005f00 guibg=#afd700 gui=bold guisp=NONE
highlight airline_a_red          guifg=#d70000 guibg=#afd700 gui=NONE guisp=NONE
highlight airline_b              guifg=#9e9e9e guibg=#303030 gui=NONE guisp=NONE
highlight airline_b_bold         guifg=#9e9e9e guibg=#303030 gui=bold guisp=NONE
highlight airline_b_red          guifg=#d70000 guibg=#303030 gui=NONE guisp=NONE
highlight airline_c              guifg=#ffffff guibg=#121212 gui=NONE guisp=NONE
highlight airline_c_bold         guifg=#ffffff guibg=#121212 gui=bold guisp=NONE
highlight airline_c_red          guifg=#d70000 guibg=#121212 gui=NONE guisp=NONE
highlight airline_warning        guifg=#080808 guibg=#d75f00 gui=NONE guisp=NONE
highlight airline_warning_bold   guifg=#080808 guibg=#d75f00 gui=bold guisp=NONE
highlight airline_warning_red    guifg=#d70000 guibg=#d75f00 gui=NONE guisp=NONE
highlight airline_a_to_airline_b guifg=#afd700 guibg=#303030 gui=NONE guisp=NONE
highlight airline_b_to_airline_c guifg=#303030 guibg=#121212 gui=NONE guisp=NONE
highlight airline_c_to_airline_x guifg=#121212 guibg=#121212 gui=NONE guisp=NONE
highlight airline_x_to_airline_y guifg=#303030 guibg=#121212 gui=NONE guisp=NONE
highlight airline_y_to_airline_z guifg=#afd700 guibg=#303030 gui=NONE guisp=NONE
highlight airline_c1_inactive    guifg=#9e9e9e guibg=#121212 gui=NONE guisp=NONE

" GitGutter
highlight GitGutterAdd          ctermfg=Green  ctermbg=NONE guifg=#00d900 guibg=NONE gui=NONE
highlight GitGutterChange       ctermfg=Yellow ctermbg=NONE guifg=#e6e600 guibg=NONE gui=NONE
highlight GitGutterDelete       ctermfg=Red    ctermbg=NONE guifg=#e60000 guibg=NONE gui=NONE
highlight GitGutterChangeDelete ctermfg=Yellow ctermbg=NONE guifg=#e6e600 guibg=NONE gui=NONE
