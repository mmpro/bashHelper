#!/usr/bin/env bash

### SETUP a config.txt file with
#CONFIG=~/.ssh/config // path to SSH config for this user
#PATH_TO_REPOS=/PATH TO REPOS e.g. /opt or /home ...
#GIT_USER=

source config.txt

read -p 'Repo Name: ' REPO_NAME

cd ~/.ssh

echo "Creating SSH Key for "$REPO_NAME
FILE=$REPO_NAME'_dk'
ssh-keygen -t rsa -N "" -b 4096 -C $REPO_NAME -f $FILE

chmod 400 $FILE

echo "Adding config to SSH"
echo "" >> $CONFIG
echo "Host $REPO_NAME.github.com" >> $CONFIG
echo "HostName github.com" >> $CONFIG
echo "User git" >> $CONFIG
echo "IdentityFile ~/.ssh/$FILE" >> $CONFIG
echo "IdentitiesOnly yes" >> $CONFIG

echo "Updating Remote URL for GIT"
cd $PATH_TO_REPOS/$REPO_NAME
git remote set-url origin git@$REPO_NAME.github.com:$GIT_USER/$REPO_NAME

echo "Copy this as deployment key"
echo ""
cat ~/.ssh/$FILE'.pub'
