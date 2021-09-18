echo "Loading Environment Values"

set -o allexport; source .env; set +o allexport


echo "-------[ ENVIRONMENT VALUES ]----------------------------------------"
echo "GIT CONFIG NAME:		$GIT_NAME"
echo "GIT CONFIG MAIL: 		$GIT_MAIL"
echo "PAM - WatchID:			$InstallWatchID"
echo "PAM - TouchID:			$InstallTouchID"
if $DontOverrideDefaults; then 
  echo "DontOverrideDefaults:		$DontOverrideDefaults"
else
  echo "Expanded Save Panel:		$ExpandSavePanelByDefault"
  echo "Subpixel Font Rendering:	$SubpxFontRender"
  echo "Fast Animations:		$SpeedUpAnimations"
  echo "Safari Debug Menu: 	$SafariDebug"
fi
echo "---------------------------------------------------------------------"



read -p "Continue (y/n)? " choice
case "$choice" in 
  y|Y ) echo "Ok. Lets get started!";;
  n|N ) echo "Good bye"; exit 0;;
  * ) echo "invalid";;
esac


echo "Creating an SSH key for you..."
ssh-keygen -t rsa -f /Users/noahkamara/.ssh/id_rsa -N ""
pbcopy < /Users/noahkamara/.ssh/id_rsa.pub

echo "Please add this public key to Github (it was copied to your clipboard)\n"
echo "https://github.com/account/ssh"
read -p "Press [Enter] key after this..."


echo "Installing xcode-stuff"
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
echo "Updating homebrew..."
brew update --quiet

echo "Installing Git..."
brew install git --quiet

echo "Git config"

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_MAIL"

echo "Installing Fishshell..."
brew install fish --quiet
echo "> fish config"
fish -c fish_update_completions;
sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
cp ./config.fish ~/.config/fish/
chsh -s /usr/local/bin/fish

echo "Installing other brew stuff..."
brew install wget --quiet

echo "Cleaning up brew"
brew cleanup --quiet

# Apps
apps=(
  1password
  vanilla
  visual-studio-code
  pycharm
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps with Cask..."
brew install --cask --appdir="/Applications" ${apps[@]} --quiet

brew cleanup --cask
brew cleanup

echo "Installing PAM Modules"
if $InstallWatchID; then
  echo "> Installing watchID"
  sudo rm -r pam-watchid
  git clone https://github.com/insidegui/pam-watchid
  sudo make install pam-watchid/
  echo 'auth sufficient pam_watchid.so "reason=execute a command as root"' | cat - /etc/pam.d/sudo > temp && sudo mv temp /etc/pam.d/sudo
  sudo rm -r pam-watchid
fi

if $InstallTouchID; then
  echo "> Installing touchID"
  sudo rm -r pam-touchID
  git clone https://github.com/Reflejo/pam-touchID
  sudo make install pam-touchid/
  echo 'auth sufficient pam_touchid.so "reason=execute a command as root"' | cat - /etc/pam.d/sudo > temp && sudo mv temp /etc/pam.d/sudo
  sudo rm -r pam-watchid
fi


if $DontOverrideDefaults; then
  exit 0
fi
echo "Modifying UserDefaults"

echo "> Setting email addresses to copy actual Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "> Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "> Setting screenshots location to ~/Desktop"
defaults write com.apple.screencapture location -string "$HOME/Desktop"

echo "> Setting screenshot format to PNG"
defaults write com.apple.screencapture type -string "png"

echo "> Making Safari's search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "> Making Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

if $ExpandSavePanelByDefault; then
  echo "> Expanding the save panel by default"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
fi

if $SubpxFontRender; then
  echo "> Enabling subpixel font rendering on non-Apple LCDs"
  defaults write NSGlobalDomain AppleFontSmoothing -int 2
fi

if $SpeedUpAnimations; then
  echo "> Enabling Safari's debug menu"
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
fi

if $SafariDebug; then
  echo "> Speeding up Mission Control animations and grouping windows by application"
  defaults write com.apple.dock expose-animation-duration -float 0.1
  defaults write com.apple.dock "expose-group-by-app" -bool true
  echo "> Setting Dock to auto-hide and removing the auto-hiding delay"
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.15
fi

echo "Done!"





