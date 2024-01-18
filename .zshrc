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
zplug "mafredri/zsh-async"                     # asynchronous processing
zplug "zsh-users/zsh-syntax-highlighting"      # Syntax Highlight
zplug "zsh-users/zsh-autosuggestions"          # command-suggestion referring history
zplug "zsh-users/zsh-completions"              # zplug completions
zplug "chrissicool/zsh-256color"               # zplug 256-color
zplug "zsh-users/zsh-history-substring-search" # zplug history-substring search

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# install NeoBundle for vim if it has not been installed
test -e $HOME/.vim/bundle/neobundle.vim || sh $HOME/dotfiles/NeoBundle_install.sh

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
export PATH="$PATH:$HOME/.nodebrew/current/bin" # nodebrew's node

autoload -Uz colors && colors # Use colors
autoload -Uz compinit && compinit # enable zsh completion

zstyle ':completion:*:default' menu select=2 # 保管候補をハイライトする

# Environmental Variable
export LANG=en_US.UTF-8        # ja_JP.UTF-8 / C.UTF-8
export LC_ALL=$LANG
export EDITOR=vim              # set vim as a default editor
export PYTHONIOENCODING=utf-8
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# history file
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 単語の区切り文字を指定する
autoload -Uz select-word-style && select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' ignore-parents parent pwd .. # ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin # sudo の後ろでコマンド名を補完する
zstyle ':completion:*:processes' command 'ps x -o pid,s,args' # ps コマンドのプロセス名補完


# PROMPT
if [[ -n "$SSH_CONNECTION" ]];then
	ISSSH="%F{cyan}[SSH]%f"
fi
PROMPT="%{$ISSSH$fg[green]%}[%n@%m]%{${reset_color}%} %~
%(!.#.$) "
# %# "
PROMPT2="%{$fg[green]%}%_> %{$reset_color%}"
SPROMPT="%{$fg[red]%}correct: %R -> %r [nyae]? %{$reset_color%}"

# insert vcs_info in the right side PROMPT (RPROMPT)
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


# key-bind
########################################
bindkey -e # enable emacs key-bind
bindkey '^R' history-incremental-pattern-search-backward # ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする


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
alias yt='yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio/best" -o "%(title)s" --add-metadata'
alias pip='pip3'
alias activate="source ./bin/activate"
alias fig='docker-compose'
alias sl='ls'
alias vmi='vim'
alias ffprobe='ffprobe -hide_banner'

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
alias grep='egrep --color --exclude-dir=.git -I'
alias v='vim'
alias vi='vim'
alias vmi='vim'
alias less='less -iNM --no-init'

alias sudo='sudo ' # enable aliasses after "sudo "

# Global Alias
alias -g L='| less'
alias -g G='| grep'

#if which pbcopy >/dev/null 2>&1 ; then
    # Mac
#    alias -g C='| pbcopy'
#elif which xsel >/dev/null 2>&1 ; then
    # Linux
#    alias -g C='| xsel --input --clipboard'
#fi

# for Linux
if [ "$OS" = 'Linux' ]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
fi

# for macOS
if [ "$OS" = 'Darwin' ]; then
  alias gdb='defaults read > before.txt && defaults -currentHost read > beforeCurrent.txt'
  alias gda='defaults read > after.txt && defaults -currentHost read > afterCurrent.txt'
  alias gdc='diff before.txt after.txt; diff beforeCurrent.txt afterCurrent.txt'
  alias wireshark='open -n /Applications/Wireshark.app/ '
fi

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

zstyle ':completion:*' group-name '' # マッチ種別を別々に表示

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # ファイル補完候補に色を付ける

# zsh options
setopt no_beep               # disable beep sound
setopt auto_cd               # change directory only with directory name
setopt auto_pushd            # automatically 'pushd' when use 'cd'
setopt pushd_ignore_dups     # don't push duplicated directory history to the directory stack
setopt interactive_comments  # treat '#' and after as comments on the CLI as well
setopt print_eight_bit       # enable display of Japanese file names
setopt no_flow_control       # disable flow-control with CTRL+S / CTRL+Q
setopt ignore_eof            # disable exit zsh with CTRL+D
setopt share_history         # share zsh history files between concurrently opened zsh sessions
setopt hist_ignore_all_dups  # don't save duplicate commands in the history
setopt hist_ignore_space     # don't save command lines starting with a space in the history
setopt hist_reduce_blanks    # reduce consecutive spaces on the command line to a single space when saving to the history
setopt hist_no_store         # don't save 'history' command to the history file
setopt brace_ccl             # enable character class expression in brace expansion
setopt auto_param_slash      # automatically appends / to directory name for the next completion
setopt mark_dirs             # if filename expansion matches a directory, append '/' to the end
setopt list_types            # ls command always with -F option
setopt auto_menu             # display completion options as a menu when use TAB key
setopt magic_equal_subst     # enable globbing after '='
setopt complete_in_word      # enable completion in a word
setopt always_last_prompt    # insert void line for big output
setopt glob_dots             # display files start from '.' when globbing
setopt extended_glob         # completion with extended glob (e.g. ~, ^)

bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

# COLOR definitions
local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local GREEN=$'%{^[[1;32m%}'$
local YELLOW=$'%{^[[1;33m%}'$
local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$


zstyle ':completion:*:manuals' separate-sections true # manの補完をセクション番号別に表示させる
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters # 変数の添字を補完する
zstyle ':completion:*' use-cache true # apt-getとかdpkgコマンドをキャッシュを使って速くする

# ディレクトリを切り替える時の色々な補完スタイル
#あらかじめcdpathを適当に設定しておく
cdpath=(~ ~/myapp/gae/ ~/myapp/gae/google_appengine/demos/)
zstyle ':completion:*:cd:*' tag-order local-directories path-directories # カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補に出す
zstyle ':completion:*:cd:*' ignore-parents parent pwd #cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):

function gcc2(){
    FILENAME=$(basename $1);
    CFILE=$(basename $1 .c);
    #gcc -o $CFILE.out -lm -ansi -pedantic -Wall $FILENAME;
    gcc -o $CFILE -lm -Wall $FILENAME;
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

stty stop undef  # fwd-i-searchが使えるようにsttyのCTRL+Sを無効化

if [ "$OS" = 'Darwin' ]; then
  # 1Password-CLI completion
  eval "$(op completion zsh)"; compdef _op op
  # Use 1Password ssh-agent
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
fi
