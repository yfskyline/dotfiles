#!/bin/sh
mkdir -p $HOME/.ssh
curl https://github.com/yfskyline.keys >> $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys
