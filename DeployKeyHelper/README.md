If you have more than one Github repository on your server and want to use Deploy Keys you can use this script to easily create the keys, add them to your ssh config and update your repository (on the server).

## Install instructions
Update the setup at the beginning of the Bash script to reflect your server's settings.
Make sure to chmod a+x the bash script and then start the script with ./deployKeyHelper.sh

The script will ask you for the repository name. Only use the Repo-Part (not the username), e.g.
```
mmpro/deployKeyHelper-repo -> deployKeyHelper
```

## Thanks
This script is based on these Gists:
+ https://gist.github.com/jamesmcfadden/d379e04e7ae2861414886af189ec59e5
+ https://gist.github.com/gubatron/d96594d982c5043be6d4
