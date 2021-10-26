#!/bin/bash
#
# defaults.sh
# Code is subject to the terms of the Mozilla Public
# License, v2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.
# Copyright 2021 Noah Kamara


# Function to print differences & write defaults
write_defaults() {
    domain=$1
    key=$2
    type=$3
    value=$4
    
    if [ "$type" = "-bool" ]; then
        if [ "$value" = "true" ]; then
            value="1"
        elif [ "$value" != "false" ]; then
            value="2"
        fi
    fi

    current_value=$(defaults read $domain $key)
    if [ "$current_value" != "$value" ]; then
        echo "> CHANGE $domain \"$key\" \"$current_value\" -> \"$value\""
    else
        echo "> LEAVE  $domain \"$key\" \"$current_value\" = \"$value\""
    fi

    defaults write $domain "$key" $type "$4"
}

#####################################################################################
##                                       Dock                                      ##
#####################################################################################


# Autohide Dock - Toggle (default: false)
write_defaults com.apple.dock "autohide" -bool "true"

# Autohide Dock - Animation Duration (default: 0.5)
write_defaults com.apple.dock "autohide-time-modifier" -float "0.5"

# Autohide Delay (default: 0.5)
write_defaults com.apple.dock "autohide-delay" -float "0.01"

# Show Recents in Dock (default: true)
write_defaults com.apple.dock "show-recents" -bool "true"

# Minimization Effect (genie, scale, suck) (default: genie)
write_defaults com.apple.dock "mineffect" -string "genie"

# Spring Loading - open file with app, when dragged on icon (default: true)
write_defaults com.apple.dock "enable-spring-load-actions-on-all-items" -bool "true"


#####################################################################################
##                                   Screenshots                                   ##
#####################################################################################

# Disable Shadow when capturing windows (default: false)
write_defaults com.apple.screencapture "disable-shadow" -bool "false"

# Include Date & Time in Screenshot (default: true)
write_defaults com.apple.screencapture "include-date" -bool "false" 

# Set Location to Desktop (default: ~/Desktop)
write_defaults com.apple.screencapture "location" -string "~/Desktop"

# Display Thumbnail (default: true)
write_defaults com.apple.screencapture "show-thumbnail" -bool "true"

# Screenshot Format (png, jpg) (default: png)
write_defaults com.apple.screencapture "type" -string "png" 


#####################################################################################
##                                      Finder                                     ##
#####################################################################################
 
# Show Hidden Files (default: false)
write_defaults com.apple.Finder "AppleShowAllFiles" -bool "true"

# Show File Extension when changing (default: true)
write_defaults com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"

# Save Documents to iCloud by default (default: true)
write_defaults NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "true" 

# toolbar title rollover delay (default: 0.5)
write_defaults NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0.2"

# Sidebar Icon Size (1-3) (default: 2)
write_defaults NSGlobalDomain "NSTableViewDefaultSizeMode" -int "2"



#####################################################################################
##                                     MenuBar                                     ##
#####################################################################################

# Flash clock time separators (default: false)
write_defaults com.apple.menuextra.clock "FlashDateSeparators" -bool "false" 

# Set Menubar Date & Time Format (datestring) (default)
write_defaults com.apple.menuextra.clock "DateFormat" -string "\"EEE MMM d  j:mm a\"" 



#####################################################################################
##                                 Mission Control                                 ##
#####################################################################################

# Rearrange spaces automatically (default: true)
write_defaults com.apple.dock "mru-spaces" -bool "true"



#####################################################################################
##                                Xcode & Simulators                               ##
#####################################################################################

# Show Build Duration in the Activity Viewer in Xcode's toolbar (default: true)
write_defaults com.apple.dt.Xcode "ShowBuildOperationDuration" -bool "true" && killall Xcode



#####################################################################################
##                                  Miscellaneous                                  ##
#####################################################################################

# TimeMachine: Don't offer new disks for Time Machine backup (default: false)
write_defaults com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true" 

# Safari: Enable Developer Menu (default: false)
write_defaults com.apple.Safari IncludeDevelopMenu -bool true



#####################################################################################
##                               Restarting Services                               ##
#####################################################################################
killall Finder
killall Dock
killall SystemUIServer