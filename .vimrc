set nocompatible
set number
set relativenumber
set cursorline
set ruler
set wildmenu
set showmode
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
set tabstop=4                                   " display width of TAB(^I)
set shiftwidth=4                                " number of spaces for smart indent
set whichwrap=b,s,[,],<,>                       " カーソルの回り込み可能にする(行末で→を押すと次の行へ
set backspace=indent,eol,start
set mouse=a
set laststatus=2
set showmatch
set history=10000
set hlsearch
set ignorecase
set shortmess-=S
set smartcase
set wrapscan

" set runtimepath+=~/src/vim-polyglot
" set wildmode=list:longest
" set nobackup					" do not make backup file
" set noswapfile				" スワップファイルを作らない
" set autoread					" 編集中のファイルが変更されたら自動で読み直す
" set hidden					" バッファが編集中でもその他のファイルを開けるように
" set showcmd					" 入力中のコマンドをステータスに表示する: 打ったコマンドをステータスラインの下に表示
" set virtualedit=onemore		" 行末の1文字先までカーソルを移動できるように
" set visualbell				" ビープ音を可視化


" Character
" set ambiwidth=double			" □や○文字が崩れる問題を解決

" Tab/Indent
" set list listchars=tab:\▸\-	" 不可視文字を可視化(タブが「▸-」と表示される)
" set softtabstop=4				" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
" set autoindent				" 改行時に前の行のインデントを継続する
" set smartindent				" 改行時に前の行の構文をチェックし次の行のインデントを増減する

autocmd FileType c setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType cpp setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType dockerfile setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType yaml setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown setlocal tabstop=4 shiftwidth=4 expandtab wrap
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 expandtab

" set termguicolors
" set background=dark

" Enable movement by display lines when wrapping
" normal mode
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" visual mode
xnoremap j gj
xnoremap k gk
xnoremap <down> gj
xnoremap <up> gk

" insert mode
onoremap j gj
onoremap k gk
onoremap <down> gj
onoremap <up> gk

" insert mode(Emacs-Keybind)
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <C-o>:call <SID>home()<CR>
imap <C-d> <Del>
imap <C-h> <BS>
inoremap <C-k> <C-o>:call setline(line('.'), col('.') == 1 ? '' : getline('.')[:col('.') - 2])<CR>

" disable Copilot default mapping
let g:copilot_no_tab_map = v:true
" Use Ctrl+e for Copilot and Emacs keybind
imap <silent><script><expr> <C-e> copilot#Accept("\<End>")

nnoremap <leader>w :w<CR>

function! s:home()
	let start_column = col('.')
	normal! ^
	if col('.') == start_column
		normal! 0
	endif
	return ''
endfunction


" NeoBundle
if has('vim_starting')
	" 初回起動時のみruntimepathにneobundleのパスを指定する
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" initialize NeoBundle
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
" NeoBundle 'violetyk/iikanji-markdown.vim'
NeoBundle 'gabrielelana/vim-markdown' " markdown対応してindent/unindentをenable
NeoBundle 'Townk/vim-autoclose'       " (を自動的に閉じる
NeoBundle 'github/copilot.vim'
call neobundle#end()

let g:markdown_enable_spell_checking = 0 "disable spell-checking of vim-markdown"
filetype plugin indent on
NeoBundleCheck " check if there are any plugins that are not installed, and ask to install them


" Highlight Full-width Space
function! FullSpace()
	highlight FullSpace cterm=underline ctermfg=magenta guibg=darkgray
endfunction

if has('syntax')
	augroup FullSpace
		autocmd!
		autocmd ColorScheme * call FullSpace()
		autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('FullSpace', '　')
	augroup END
	call FullSpace()
endif

syntax enable
