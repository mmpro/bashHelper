If you have more than one Github repository on your server and want to use Deploy Keys you can use this script to easily create the keys, add them to your ssh config and update your repository (on the server).

## Install instructions
Update the setup at the beginning of the Bash script to reflect your server's settings.
Make sure to chmod a+x the bash script and then start the script with ./deployKeyHelper.sh

The script will ask you for the repository name. Only use the Repo-Part (not the username), e.g.
```
mmpro/deployKeyHelper-repo -> deployKeyHelper
```

## Usage
The script will create a new key pair in ~/.ssh:
+ repositoryName_dk
+ repositoryName_dk.pub
The latter will be displayed in the console. Copy and add it to your Github repository (Settings/Deploy Keys). Give it a meaningful name and do not allow write access (unless you really want it).

The script will also create or update ~/.ssh/config with an entry like this:
```
Host repositoryName.github.com
HostName github.com
User git
IdentityFile ~/.ssh/repositoryName_dk
IdentitiesOnly yes
```

Test the connection to Github
```
ssh -vT git@repositoryName.github.com
```
IMPORTANT: You cannot use github.com as domain. You must use your repository name as a subdomain!

Clone the repository
Copy the URL from Github and then add the subdomain
```
Github URL
git clone git@github.com:USER/REPOSITORYNAME.git
Change it to
git clone git@repositoryName.github.com:USER/REPOSITORYNAME.git
```

## Thanks
This script is based on these Gists:
+ https://gist.github.com/jamesmcfadden/d379e04e7ae2861414886af189ec59e5
+ https://gist.github.com/gubatron/d96594d982c5043be6d4
