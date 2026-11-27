" HackMD One Dark-style highlighting for raw Markdown.
" Install as ~/.vim/after/syntax/markdown.vim.
" Replace only this buffer's syntax; keep the existing Vim color settings.
if &l:filetype !=# 'markdown'
	finish
endif

syntax clear
syntax case match
syntax sync fromstart

" Palette (True Color, with approximate 256-color fallbacks)
highlight PkmMdText    guifg=#abb2bf gui=NONE ctermfg=249 cterm=NONE
highlight PkmMdHeading guifg=#eda35e gui=bold ctermfg=215 cterm=bold
highlight PkmMdBlue    guifg=#6699cc gui=NONE ctermfg=68  cterm=NONE
highlight PkmMdRed     guifg=#f76e79 gui=NONE ctermfg=203 cterm=NONE
highlight PkmMdGreen   guifg=#98c379 gui=NONE ctermfg=114 cterm=NONE
highlight PkmMdCode    guifg=#5c6370 gui=italic ctermfg=59 cterm=italic
highlight PkmMdStrong  guifg=#eda35e gui=bold ctermfg=215 cterm=bold
highlight PkmMdEm      guifg=#abb2bf gui=italic ctermfg=249 cterm=italic

" Inline syntax. No math rule: '$' is ordinary text.
syntax match PkmMdEscape /\\[][\\`*_{}()<>#+.!-]/ contained
syntax match PkmMdLabel /!\?\[\%([^]\\]\|\\.\)*\]\ze(/ contained nextgroup=PkmMdUrl
syntax match PkmMdUrl /(\%([^()\\]\|\\.\|([^()]*)\)*)/ contained
syntax match PkmMdBareUrl +\<https\?://[^[:space:]<>]\++ contained
syntax match PkmMdEm /\%([[:alnum:]*]\)\@<!\*[^*[:space:]]\%([^*]*[^*[:space:]]\)\?\*\%(\*\)\@!/ contained
syntax match PkmMdEm /\<_\%(_\)\@!\S\%([^_]*\S\)\?_\%(\w\)\@!/ contained
syntax match PkmMdStrong /\*\*[^*[:space:]]\%([^*]*[^*[:space:]]\)\?\*\*/ contained
syntax match PkmMdStrong /\<__[^_[:space:]]\%([^_]*[^_[:space:]]\)\?__\%(\w\)\@!/ contained
syntax region PkmMdInlineCode start=/\%(`\)\@<!\z(`\+\)\%(`\)\@!/ end=/\%(`\)\@<!\z1\%(`\)\@!/ oneline keepend contained
syntax cluster PkmMdInline contains=PkmMdEscape,PkmMdLabel,PkmMdBareUrl,PkmMdEm,PkmMdStrong,PkmMdInlineCode
highlight! link PkmMdEscape PkmMdText
highlight! link PkmMdLabel PkmMdGreen
highlight! link PkmMdUrl PkmMdBlue
highlight! link PkmMdBareUrl PkmMdBlue
highlight! link PkmMdInlineCode PkmMdCode

" Ordinary lines, then higher-priority block matches.
syntax match PkmMdText /^.*$/ contains=@PkmMdInline
syntax match PkmMdHeading /^ \{0,3}#\{1,6}\%(\s\|$\).*$/ contains=@PkmMdInline
syntax match PkmMdHeading /^\S.*\n[=-]\+\s*$/ contains=@PkmMdInline
syntax match PkmMdCode /^\s*\%(-\s*\)\{3,}$/
syntax match PkmMdCode /^\s*\%(\*\s*\)\{3,}$/
syntax match PkmMdCode /^\s*\%(_\s*\)\{3,}$/

" Lists: four spaces or one TAB per level; repeat blue/red/green.
" Use a repeating regex instead of a fixed maximum nesting depth.
let s:indent = '\%( \{4}\|\t\)'
let s:marker = '\%([-+*]\|\d\+[.)]\)\%(\s\|$\).*'
for s:level in range(0, 2)
	let s:group = ['PkmMdBlue', 'PkmMdRed', 'PkmMdGreen'][s:level]
	execute 'syntax match ' . s:group . ' /^\%(' . s:indent . '\{3}\)*' . s:indent . '\{' . s:level . '\}' . s:marker . '$/ contains=@PkmMdInline'
endfor
unlet s:indent s:marker s:level s:group

" Fenced code blocks take precedence over headings, lists and links.
" An opening fence of N characters requires at least N to close.
syntax region PkmMdFence start=/^\s*\z(`\{3,\}\)\%(`\)\@!.*$/ end=/^\s*\z1`*\s*$/ keepend
syntax region PkmMdFence start=/^\s*\z(\~\{3,\}\)\%(\~\)\@!.*$/ end=/^\s*\z1\~*\s*$/ keepend
highlight! link PkmMdFence PkmMdCode

let b:current_syntax = 'markdown'
