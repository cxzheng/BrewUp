#!/bin/bash
PATH="/usr/local/bin:/usr/local/sbin:/Users/${USER}/.local/bin:/usr/bin:/usr/sbin:/bin:/sbin"

#SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
#$SCRIPT_DIR/pip-up.sh

## Fix for brew doctor warnings if using pyenv
if which pyenv >/dev/null 2>&1; then
  brew='env PATH=${PATH//$(pyenv root)\/shims:/} brew'
fi

DATE=$(date '+%Y%m%d.%H%M')
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)
brewFileName="Brewfile.${HOSTNAME}"

echo "${yellow}==>${reset} Updating pip3 packages..."
pip3 freeze --user | cut -d'=' -f1 | xargs -n1 pip3 install -U
echo -e "${green}==>${reset} pip3 update Finished.\n"

# Sets Working Dir as Real A Script Location
if [ -z $(which realpath) ]; then
  brew install coreutils
fi
cd $(dirname "$(realpath "$0")")

echo "${green}==>${reset} Checkout from git repo ..."
git pull 2>&1

# checks if mas, terminal-notifier are installed, if not will promt to install
if [ -z $(which mas) ]; then
  brew install mas
fi

# Brew Diagnotic
echo -e "\n${yellow}==>${reset} Running Brew Diagnotic..."
brew doctor 2>&1
brew missing 2>&1
echo -e "${green}==>${reset} Brew Diagnotic Finished.\n"

# Brew packages update and cleanup
echo "${yellow}==>${reset} Running Updates..."
brew update 2>&1
brew outdated 2>&1
brew upgrade 2>&1
brew cleanup -s 2>&1
echo -e "${green}==>${reset} Finished Updates.\n"

# App Store Updates
echo "${yellow}==>${reset} Running AppStore Updates..."
mas outdated 2>&1
mas upgrade 2>&1
echo -e "${green}==>${reset} AppStore Updates Finished.\n"

# Creating Dump File with hostname
brew bundle dump --force --file="./${brewFileName}"

# Pushing to Repo
echo "${green}==>${reset} Push changes to git repo ..."
git add . 2>&1
git commit -m "${DATE}_update" 2>&1
git push 2>&1

echo "${green}==>${reset} All Updates & Cleanups Finnished"
