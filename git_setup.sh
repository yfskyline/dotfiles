git config --global user.name "Yuta Fukagawa"
git config --global user.email 25516089+yfskyline@users.noreply.github.com
git config --global core.editor vim
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --list

mkdir -p ~/.config/git && cp .gitignore_global ~/.config/git/ignore
