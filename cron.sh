echo "*/10 * * * * $HOME/dotfiles/ssh-keys.sh" >> /etc/crontab
echo "*/10 * * * * cd $HOME/dotfiles/ && git pull" >> /etc/crontab
