# set $OS
if [ "$(uname)" = 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW32_NT' ]; then                                               
  OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# install zplug if it has not been installed
test -d $HOME/.zplug || curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# zplug
if [ $OS = 'Linux' ]; then
	test $(stat $HOME/.zplug -c '%u') -eq $(id -u) || sudo chown -R $(whoami) $HOME/.zplug
elif [ $OS = 'Mac' ]; then
	test $(stat -f '%u' $HOME/.zplug) -eq $(id -u) || sudo chown -R $(whoami) $HOME/.zplug
	if [ $(uname -m) = 'x86_64' ]; then
		test $(stat -f '%u' /usr/local/share/zsh) -eq $(id -u) || sudo chown -LR $(whoami) /usr/local/share/
	fi
fi
source $HOME/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# 非同期処理
zplug "mafredri/zsh-async"
# Syntax Highlight(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# command-suggestion referring history
zplug "zsh-users/zsh-autosuggestions"
# zplug completions
zplug "zsh-users/zsh-completions"
# zplug 256-color
zplug "chrissicool/zsh-256color"
# zplug history-substring search
zplug "zsh-users/zsh-history-substring-search"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# install NeoBundle for vim if it has not been installed
test -e $HOME/.vim/bundle/neobundle.vim || sh ./NeoBundle_install.sh

### PATH ###
# source zplug plugins and add commands to $PATH
zplug load

export PATH="$PATH:/usr/local/opt/libpcap/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/local/opt/gnu-getopt/bin"
#export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
# eval "$(pyenv init -)"
# for user scripts
export PATH="$PATH:$HOME/bin"
test -d $HOME/bin || mkdir $HOME/bin
# nodebrew's node
export PATH="$PATH:$HOME/.nodebrew/current/bin"

# 色を使用出来るようにする
autoload colors
colors
PROMPT="%{$fg[green]%}%m%(!.#.$) %{$reset_color%}"
PROMPT2="%{$fg[green]%}%_> %{$reset_color%}"
SPROMPT="%{$fg[red]%}correct: %R -> %r [nyae]? %{$reset_color%}"
RPROMPT="%{$fg[cyan]%}[%~]%{$reset_color%}"

# zshの補完機能を有効にする
autoload -Uz compinit && compinit
#保管候補をハイライトする
zstyle ':completion:*:default' menu select=2

# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
# 環境変数
export LANG=en_US.UTF-8
#export LANG=ja_JP.UTF-8
#export LANG=C
#export LANG=C.UTF-8
export LC_ALL=$LANG
export EDITOR=vim #デフォルトエディタをvimに設定
export PYTHONIOENCODING=utf-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################



# Aliases
########################################
alias lah='ls -lah'
alias ll='ls -l'
alias relogin='exec $SHELL -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias py='python3 '
alias python='python3'
alias youtube-dl="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "
alias pip='pip3'
alias activate="source ./bin/activate"
alias fig='docker-compose'
alias sl='ls'

# for macOS
alias gdb='defaults read > before.txt && defaults -currentHost read > beforeCurrent.txt'
alias gda='defaults read > after.txt && defaults -currentHost read > afterCurrent.txt'
alias gdc='diff before.txt after.txt; diff beforeCurrent.txt afterCurrent.txt'

# Git
alias g='git'
alias gb='git branch'
alias gs='git status'
alias gc='git checkout'
alias gcm='git commit -m'
alias gd='git diff'
alias gp='git push'
alias ga='git add'
alias gl='git log'
alias v='vim'
alias vi='vim'
alias vmi='vim'
alias less='less -iNM --no-init'
alias yt='yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio/best" -o "%(title)s" --add-metadata'
#alias yt='yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio/best" -o "%(title)s"'
#alias pbcopy='xsel --clipboard --input'
#alias pbpaste='xsel --clipboard --output'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
#if which pbcopy >/dev/null 2>&1 ; then
    # Mac
#    alias -g C='| pbcopy'
#elif which xsel >/dev/null 2>&1 ; then
    # Linux
#    alias -g C='| xsel --input --clipboard'
#elif which putclip >/dev/null 2>&1 ; then
#    # Cygwin
#    alias -g C='| putclip'
#fi



########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# 名前で色を付けるようにする
autoload colors
colors

# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補完に関するオプション
# http://voidy21.hatenablog.jp/entry/20090902/1251918174
setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt interactive_comments  # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt print_eight_bit  #日本語ファイル名等8ビットを通す
setopt extended_glob  # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ

bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

# 色の定義
local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local GREEN=$'%{^[[1;32m%}'$
local YELLOW=$'%{^[[1;33m%}'$
local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$

# 範囲指定できるようにする
# 例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt brace_ccl

# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true

# 変数の添字を補完する
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# apt-getとかdpkgコマンドをキャッシュを使って速くする
zstyle ':completion:*' use-cache true

# ディレクトリを切り替える時の色々な補完スタイル
#あらかじめcdpathを適当に設定しておく
cdpath=(~ ~/myapp/gae/ ~/myapp/gae/google_appengine/demos/)
# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補に出す
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
#cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd



function gcc2(){
    FILENAME=$(basename $1);
    CFILE=$(basename $1 .c);
    #gcc -o $CFILE.out -lm -ansi -pedantic -Wall $FILENAME;
    gcc -o $CFILE -lm -Wall $FILENAME;
}


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# fwd-i-searchが使えるようにsttyのCTRL+Sを無効化
stty stop undef

# 1Password-CLI completion
eval "$(op completion zsh)"; compdef _op op

# Use 1Password ssh-agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
