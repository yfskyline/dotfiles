# Aliases
alias lah='ls -lah'
alias ll='ls -l'
alias l='ls'
alias sl='ls'
alias relogin='exec $SHELL -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias py='python3 '
alias python='python3'
alias pip='pip3'
alias activate="source ./bin/activate"
alias youtube-dl="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "
alias yt='yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio/best" -o "%(title)s" --add-metadata --cookies-from-browser chrome'
alias fig='docker-compose'
alias ffprobe='ffprobe -hide_banner'
alias g='git'
alias gb='git branch'
alias gs='git status'
alias gc='git checkout'
alias gcm='git commit -m'
alias gd='git diff'
alias gp='git push'
alias ga='git add'
alias gl='git log'
alias grep='grep -E --color --exclude-dir=.git -I'
alias v='vim'
alias vi='vim'
alias vmi='vim'
alias mtr='mtr -z'
alias less='less -iNM --no-init'
alias sudo='sudo ' # enable aliasses after "sudo "
alias deploy='sudo containerlab deploy'
alias destroy='sudo containerlab destroy'
alias ffmpeg='ffmpeg -hide_banner'
alias color='for fore in `seq 30 37`; do printf "\e[${fore}m \\\e[${fore}m \e[m\n"; for mode in 1 4 5; do printf "\e[${fore};${mode}m \\\e[${fore};${mode}m \e[m"; for back in `seq 40 47`; do printf "\e[${fore};${back};${mode}m \\\e[${fore};${back};${mode}m \e[m"; done; echo; done; echo; done; printf " \\\e[m\n"'

if [ -n "$ZSH_VERSION" ]; then
	# Global Alias
	alias -g L='| less'
	alias -g G='| grep'
	if [ "$OS" = 'Linux' ]; then
		alias -g C='| xsel --input --clipboard'
	elif [ "$OS" = 'Mac' ]; then
		alias -g C='| pbcopy'
	fi
fi


# OS specific alias
if [ "$OS" = 'Linux' ]; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
	alias ls='ls -F --color=auto'
	alias fd='fdfind'
	alias apt='apt-fast'
elif [ "$OS" = 'Mac' ]; then
	alias defaults_before='defaults read > before.txt && defaults -currentHost read > beforeCurrent.txt'
	alias defaults_after='defaults read > after.txt && defaults -currentHost read > afterCurrent.txt && diff --color before.txt after.txt && diff --color beforeCurrent.txt afterCurrent.txt'
	alias defaults_compare='diff --color before.txt after.txt; diff beforeCurrent.txt afterCurrent.txt'
	alias wireshark='open -n /Applications/Wireshark.app/ '
	alias ls='ls -G -F'
	export CLICOLOR=1
fi
