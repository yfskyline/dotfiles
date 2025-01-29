" General Settings
set number
set relativenumber
set cursorline
set ruler
set wildmenu
set showmode
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set termencoding=utf-8
set fileformats=unix,dos,mac
set tabstop=4                                   " display width of TAB(^I)
set shiftwidth=4                                " number of spaces for smart indent
set whichwrap=b,s,h,l,<,>,[,],~
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
set virtualedit=onemore

" Character Settings
" set ambiwidth=double			" □や○文字が崩れる問題を解決

" Tab/Indent Settings
" set list listchars=tab:\▸\-	" 不可視文字を可視化(タブが「▸-」と表示される)
" set softtabstop=4				" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
" set autoindent				" 改行時に前の行のインデントを継続する
" set smartindent				" 改行時に前の行の構文をチェックし次の行のインデントを増減する

scriptencoding utf-8

filetype plugin indent on
augroup FileTypeSettings
	autocmd!
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
augroup END

" Uncomment and configure as needed
" set termguicolors
" set background=dark
" set wildmode=list:longest
" set nobackup					" do not make backup file
" set noswapfile				" スワップファイルを作らない
" set autoread					" 編集中のファイルが変更されたら自動で読み直す
" set hidden					" バッファが編集中でもその他のファイルを開けるように
" set showcmd					" 入力中のコマンドをステータスに表示する: 打ったコマンドをステータスラインの下に表示
" set visualbell				" ビープ音を可視化


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

" insert mode (Emacs-Keybind)
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <C-o>:call <SID>home()<CR>
imap <C-d> <Del>
imap <C-h> <BS>
inoremap <C-k> <C-o>:call setline(line('.'), col('.') == 1 ? '' : getline('.')[:col('.') - 2])<CR>

" Disable Copilot default mapping
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


let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = expand(s:dein_dir . '/repos/github.com/Shougo/dein.vim')

if has('vim_starting')
	" set runtimepath+=~/src/vim-polyglot
	if isdirectory(s:dein_repo_dir)
		execute 'set runtimepath+=' . s:dein_repo_dir
	endif
	set runtimepath+=expand("~/.cache/dein")

	if !isdirectory(expand('~/.cache/dein'))
		echo 'Please install dein.vim by running the following command:'
		echo "sh -c '$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh)'"
	endif
endif

let g:markdown_enable_spell_checking = 0 "disable spell-checking of vim-markdown"

"----------------------------------------------------------
" CtrlP
"----------------------------------------------------------
let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

" CtrlPFunkyの絞り込み検索設定
let g:ctrlp_funky_matchtype = 'path'

if executable('ag')
	let g:ctrlp_use_caching=0 " CtrlPのキャッシュを使わない
	let g:ctrlp_user_command='ag %s -i --hidden -g ""' " agの検索設定
endif

if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)

	let g:rc_dir = expand('~/dotfiles/vim')
	let s:toml	 = g:rc_dir . '/dein.toml'
	let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

	call dein#load_toml(s:toml,			{'lazy': 0})
	call dein#load_toml(s:lazy_toml,	{'lazy': 1})

	call dein#end()
	call dein#save_state()
endif

if dein#check_install()
	call dein#install()
endif

let g:airline_theme = 'powerlineish'
let g:airline_section_x = airline#section#create_right(['%{&modified?"⚡":"✔"}'])
let g:ale_linters = {
	\ 'python': ['flake8'],
	\ 'javascript': ['eslint'],
	\ 'typescript': ['eslint'],
	\ 'css': ['stylelint'],
	\ 'html': ['htmlhint'],
	\ 'json': ['jsonlint'],
	\ 'yaml': ['yamllint'],
	\ 'markdown': ['markdownlint'],
	\ 'dockerfile': ['hadolint'],
	\ 'vim': ['vint'],
	\ 'sh': ['shellcheck'],
	\ 'bash': ['shellcheck'],
	\ 'zsh': ['shellcheck'],
	\}
let g:ale_sign_column_always = 1
nmap <silent> <C-n> :ALENext<CR>
nmap <silent> <C-p> :ALEPrevious<CR>
nmap <silent> <C-j> :ALENext<CR>
nmap <silent> <C-k> :ALEPrevious<CR>

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

" GitGutter ColorSetting
augroup ColorSchemeSettings
	autocmd!
	autocmd ColorScheme * highlight SignColumn		ctermbg=NONE
	autocmd ColorScheme * highlight GitGutterAdd	ctermfg=Green ctermbg=NONE
	autocmd ColorScheme * highlight GitGutterChange	ctermfg=Yellow ctermbg=NONE
	autocmd ColorScheme * highlight GitGutterDelete	ctermfg=Red ctermbg=NONE
augroup END

colorscheme default
