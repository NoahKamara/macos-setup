

# What the install.sh does, step by step:

## Initial Configuration & Apps

### HomeBrew
 - Install XCode Stuff
 - Check for Homebrew,
 - Install if we don't have it
 - Update homebrew recipes

### SSH, Git & Other Dev Stuff
 - Install Git
 - Set Git Username
 - Set Git Email
 - Create SSH Key
 - Prompt to add to Github
 - Install Brew Apps

### FishShell
 - Install FishShell
 - Update Completions
 - Add To Shells & Set as Default
 - Copy Configuration

### App Store Apps
 - Install AppStore CLI
 - Sign Into AppStore
 - Install AppStore Apps
 - Install apps to /Applications
 - Default is: /Users/$user/Applications

### PAM Modules WatchID & TouchID
 - Installing WatchID
 - Installing TouchID

# Setting Defaults

### Dock
 - Autohide Dock - Toggle (default: false)
 - Autohide Dock - Animation Duration (default: 0.5)
 - Autohide Delay (default: 0.5)
 - Show Recents in Dock (default: true)
 - Minimization Effect (genie, scale, suck) (default: genie)
 - Spring Loading - open file with app, when dragged on icon (default: true)

### Screenshots
 - Disable Shadow when capturing windows (default: false)
 - Include Date & Time in Screenshot (default: true)
 - Set Location to Desktop (default: ~/Desktop)
 - Display Thumbnail (default: true)
 - Screenshot Format (png, jpg) (default: png)

### Finder
 - Show Hidden Files (default: false)
 - Show File Extension when changing (default: true)
 - Save Documents to iCloud by default (default: true)
 - toolbar title rollover delay (default: 0.5)
 - Sidebar Icon Size (1-3) (default: 2)

### MenuBar
 - Flash clock time separators (default: false)
 - Set Menubar Date & Time Format (datestring) (default)

### Mission Control
 - Rearrange spaces automatically (default: true)

### Xcode & Simulators
 - Show Build Duration in the Activity Viewer in Xcode's toolbar (default: true)

### Miscellaneous
 - TimeMachine: Don't offer new disks for Time Machine backup (default: false)
 - Safari: Enable Developer Menu (default: false)

### Restarting Services