set runtimepath+=~/src/vim-polyglot
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

" adjust indent to 4
set tabstop=4 " file内のタブ文字の表示幅
set shiftwidth=4 " 自動インデントに使われる文字数

set number " 行番号の表示,現在行数を絶対表示 "
set relativenumber "行数を相対表示"
set whichwrap=b,s,[,],<,> " カーソルの回り込み可能にする(行末で→を押すと次の行へ
set backspace=indent,eol,start " バックスペースを空白、行末、行頭でも使えるようにする
set mouse=a "マウスホイールを利用する"
set cursorline

" search
set ic " 検索時に大文字/小文字を区別しない

" insert mode (vim裏切り設定)
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


" Start NeoBundle Settings.
if has('vim_starting')
   " 初回起動時のみruntimepathにneobundleのパスを指定する
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" NeoBundleを初期化
call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするプラグインをここに記述
" NeoBundle 'violetyk/iikanji-markdown.vim'
NeoBundle 'gabrielelana/vim-markdown' " markdown対応してindent/unindentをenable
NeoBundle 'Townk/vim-autoclose' " (を自動的に閉じる
NeoBundle 'mattn/emmet-vim' " enable Emmet

call neobundle#end()

let g:markdown_enable_spell_checking = 0 "disable spell-checking of vim-markdown"

NeoBundleCheck " 未インストールプラグインがあったらインストールするか尋ねる
" End NeoBundle Settings.

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on


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
""""""""""""""""""""""""""""""

syntax enable
