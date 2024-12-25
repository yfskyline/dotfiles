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
" 折り返し時に表示行単位での移動できるようにする


" 文字
" set ambiwidth=double			" □や○文字が崩れる問題を解決

" タブ・インデント
" set list listchars=tab:\▸\-	" 不可視文字を可視化(タブが「▸-」と表示される)
" set expandtab					" Tab文字を半角スペースにする: タブ入力を複数の空白入力に置き換える
" set softtabstop=4				" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
" set autoindent				" 改行時に前の行のインデントを継続する
" set smartindent				" 改行時に前の行の構文をチェックし次の行のインデントを増減する

" set termguicolors
" set background=dark


" insert mode(Emacs-Keybind)
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <C-o>:call <SID>home()<CR>
imap <C-e> <End>
imap <C-d> <Del>
imap <C-h> <BS>
" imap <C-k> <C-r>=<SID>kill()<CR>
inoremap <C-k> <C-o>:call setline(line('.'), col('.') == 1 ? '' : getline('.')[:col('.') - 2])<CR>

function! s:home()
	let start_column = col('.')
	normal! ^
	if col('.') == start_column
	側 normal! 0
	endif
	return ''
endfunction

function! s:kill()
	let [text_before, text_after] = s:split_line()
	if len(text_after) == 0
	側 normal! J
	else
	側 call setline(line('.'), text_before)
	endif
	return ''
endfunction

function! s:split_line()
	let line_text = getline(line('.'))
	let text_after  = line_text[col('.')-1 :]
	let text_before = (col('.') > 1) ? line_text[: col('.')-2] : ''
	return [text_before, text_after]
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
