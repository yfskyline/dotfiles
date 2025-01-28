#!/bin/bash

git config --global user.name "Yuta Fukagawa"
git config --global user.email 25516089+yfskyline@users.noreply.github.com
git config --global core.editor vim
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global pull.ff only
git config --global pull.rebase true
git config --global fetch.prune true
git config --list

mkdir -p ~/.config/git && cp /home/"$HOME"/dotfiles/git/.gitignore_global ~/.config/git/ignore
