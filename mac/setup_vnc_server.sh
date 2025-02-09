#!/bin/bash
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw mypasswd -restart -agent -privs -all
echo -e "Please check System Preferences -> Sharing -> Remote Management -> Computer Settings -> VNC viewers may control screen with password: mypasswd"
