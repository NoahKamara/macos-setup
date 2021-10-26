#!/bin/bash
#
# defaults.sh
# Code is subject to the terms of the Mozilla Public
# License, v2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.
# Copyright 2021 Noah Kamara


# Loading Environment Variables
set -o allexport; source .env; set +o allexport


# Load Apps in Array
IFS=',' read -r -a apps <<< "$APPSTORE_APPS"
IFS=',' read -r -a brewapps <<< "$BREW_APPS"


echo "-------[ ENVIRONMENT VALUES ]----------------------------------------"
echo "GIT CONFIG NAME:		$GIT_NAME"
echo "GIT CONFIG MAIL: 		$GIT_MAIL"
echo "PAM - WatchID:			$InstallWatchID"
echo "PAM - TouchID:			$InstallTouchID"
echo "INSTALL Brew Casks:"
for app in "${apps[@]}"
do
   echo "				$app"
done
echo "INSTALL AppStore Apps:"
for app in "${brewapps[@]}"
do
   echo "				$app"
done
echo "---------------------------------------------------------------------"


# Ask for Confirmation
read -p "Continue (y/n)? " choice
case "$choice" in 
  y|Y ) echo "Ok. Lets get started!";;
  n|N ) echo "Good bye"; exit 0;;
  * ) echo "invalid";;
esac



#####################################################################################
##                                     HomeBrew                                    ##
#####################################################################################

# Install XCode Stuff
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  sh $0
  exit
fi

# Update homebrew recipes
brew update --quiet



#####################################################################################
##                            SSH, Git & Other Dev Stuff                           ##
#####################################################################################

# Install Git
brew install git --quiet

# Set Git Username
git config --global user.name "$GIT_NAME"

# Set Git Email
git config --global user.email "$GIT_MAIL"

# Create SSH Key
ssh-keygen -t rsa -f /Users/noahkamara/.ssh/id_rsa -N ""
pbcopy < /Users/noahkamara/.ssh/id_rsa.pub

# Prompt to add to Github
echo "Please add this public key to Github (it was copied to your clipboard)\n"
echo "https://github.com/account/ssh"
read -p "Press [Enter] key after this..."

echo "Installing other brew stuff..."
brew install wget --quiet

# Install Brew Apps
IFS=',' read -r -a brewapps <<< "$BREW_APPS"


#####################################################################################
##                                    FishShell                                    ##
#####################################################################################


# Install FishShell
echo "> Installing & Configuring Fish"
brew install fish --quiet

# Update Completions
fish -c fish_update_completions;

# Add To Shells & Set as Default
sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
sudo chsh -s /usr/local/bin/fish

# Copy Configuration
cp ./config/config.fish ~/.config/fish/



#####################################################################################
##                                  App Store Apps                                 ##
#####################################################################################

# Install AppStore CLI
brew install mas-cli/tap/mas

# Sign Into AppStore
mas signin --dialog $APPLEID_MAIL

# Install AppStore Apps
IFS=',' read -r -a apps <<< "$APPSTORE_APPS"
for app in "${apps[@]}"; do
  mas install $app
done


# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps with Cask..."
for app in "${brewapps[@]}"; do
   brew install --cask --appdir="/Applications" $app --quiet
done



#####################################################################################
##                          PAM Modules WatchID & TouchID                          ##
#####################################################################################

# Installing WatchID
if $InstallWatchID; then
  sudo rm -r pam-watchid
  git clone https://github.com/insidegui/pam-watchid
  sudo make install pam-watchid/
  echo 'auth sufficient pam_watchid.so "reason=execute a command as root"' | cat - /etc/pam.d/sudo > temp && sudo mv temp /etc/pam.d/sudo
  sudo rm -r pam-watchid
fi

# Installing TouchID
if $InstallTouchID; then
  sudo rm -r pam-touchID
  git clone https://github.com/Reflejo/pam-touchID
  sudo make install pam-touchid/
  echo 'auth sufficient pam_touchid.so "reason=execute a command as root"' | cat - /etc/pam.d/sudo > temp && sudo mv temp /etc/pam.d/sudo
  sudo rm -r pam-watchid
fi



#####################################################################################
##                                   Housekeeping                                  ##
#####################################################################################

# Clean Up Brew
brew cleanup --quiet


#####################################################################################
##                                 Setting Defaults                                ##
#####################################################################################
./scripts/defaults.sh 