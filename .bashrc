# define message
RED="\033[31;1m"
GREEN="\033[32;1m"
YELLOW="\033[33;1m"
BLUE="\033[34;1m"
CYAN="\033[36;1m"
RESET="\033[0m"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED ]${RESET}"
LOG="${CYAN}[LOG    ]${RESET}"
# COLOR definitions
DEFAULT=$'%{^[[m%}'$
RED=$'%{^[[1;31m%}'$
GREEN=$'%{^[[1;32m%}'$
YELLOW=$'%{^[[1;33m%}'$
BLUE=$'%{^[[1;34m%}'$
PURPLE=$'%{^[[1;35m%}'$
LIGHT_BLUE=$'%{^[[1;36m%}'$
WHITE=$'%{^[[1;37m%}'$

# set $OS
if [ "$(uname)" = 'Darwin' ]; then
	OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
	OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW32_NT' ]; then
	OS='Cygwin'
else
	echo -e "${LOG}Your platform ($(uname -a)) is not supported."
	exit 1
fi

# install zplug if it has not been installed
test -d "$HOME"/.zplug || curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# zplug
if [ $OS = 'Linux' ]; then
	test $(stat $HOME/.zplug -c '%u') -eq $(id -u) || sudo chown -R $(whoami) $HOME/.zplug
elif [ $OS = 'Mac' ]; then
	test $(stat -f '%u' $HOME/.zplug) -eq $(id -u) || sudo chown -R $(whoami) $HOME/.zplug
	if [ $(uname -m) = 'x86_64' ]; then
		test $(stat -f '%u' /usr/local/share/zsh) -eq $(id -u) || sudo chown -LR $(whoami) /usr/local/share/
	fi
fi

# install dein.vim if it has not been installed
test -e "$HOME"/.cache/dein || sh "$HOME"/dotfiles/vim/install_dein.sh

# PATH
export PATH="$PATH:/usr/local/opt/libpcap/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/local/opt/gnu-getopt/bin"

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"

# nvm
if [ $OS = 'Linux' ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
elif [ $OS = 'Mac' ]; then
	export NVM_DIR="$HOME/.nvm"
	source "$(brew --prefix nvm)"/nvm.sh
fi

# for user scripts
export PATH="$PATH:$HOME/bin"
test -d $HOME/bin || mkdir $HOME/bin

# Environmental Variable
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export EDITOR=vim
export PYTHONIOENCODING=utf-8
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# history file
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# PROMPT
if [[ -n "$SSH_CONNECTION" ]];then
	ISSSH="%F{cyan}[SSH]%f"
fi

set_prompt() {
	local venv=""
	if [[ -n "$VIRTUAL_ENV" ]]; then
		venv="(%{$fg[cyan]%}$(basename $VIRTUAL_ENV)%{$reset_color%})"
	fi

	if [ $? = 0 ]; then
		PROMPT="${venv}%{$ISSSH$fg[green]%}[%n@%m]%{${reset_color}%} %~"$'\n'"%(!.#.$) "
	else
		PROMPT="${venv}%{$ISSSH$fg[red]%}[%n@%m]%{${reset_color}%} %~"$'\n'"%(!.#.$) "
	fi
}

precmd() {
	set_prompt
}

# Aliases
[ -f ~/dotfiles/.aliases.sh ] && source ~/dotfiles/.aliases.sh

stty stop undef              # fwd-i-searchが使えるようにsttyのCTRL+Sを無効化

function gcc2(){
	FILENAME=$(basename $1);
	CFILE=$(basename $1 .c);
	#gcc -o $CFILE.out -lm -ansi -pedantic -Wall $FILENAME;
	gcc -o "$CFILE" -lm -Wall "$FILENAME";
}

if [ "$OS" = 'Mac' ]; then
	# Use 1Password ssh-agent
	export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
fi

cat "$HOME"/dotfiles/asciiart_skyline.txt
