# -------------------- GENERAL -------------------- #

## if user is not root, pass all commands via sudo #
if test (id -u) -eq 0
    alias reboot="sudo reboot"
end


## execute previour command with superuser privs
function pls
    eval command sudo $history[1]
end

# -------------------- CONSOLE -------------------- #

## Reload Shell
alias resource="source ~/.config/fish/config.fish"

## Clear Screen
alias c="clear"

# ## Colorize the ls output ##
# alias ls="ls "

## Use a long listing format ##
alias ll="ls -la"

## a quick way to get out of current directory ##
alias ..="cd .."
alias ...="cd ../../../"

# Last Command
function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end



# -------------------- DEVELOPER TOOLS -------------------- #

## HTTP Server from directory
function www
    set _flag_port 80
    argparse --name=www 'p/port=' -- $argv
    echo "http://0.0.0.0:$_flag_port"
    python -m SimpleHTTPServer $_flag_port
end
alias serve="www"

## Get Local & External IP
function ip
    # Internal IP
    echo -n "INTERNAL: "
    switch (uname)
        case "Darwin"; ipconfig getifaddr en0
        case "Linux"
            switch (uname -n)
                case "NK-ARCH"; /usr/bin/ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'
                case "NK-FED"; hostname -i | awk '{print $3}'
            end
    end

    # External IP
    echo "EXTERNAL: " (curl -s ipinfo.io/ip)
end

## Downloader
alias wget="wget -c "

# ------------------ SPEEDTEST ------------------ #
function speed
    set _flag_single 1
    argparse --name=speed u/up d/down s/single -- $argv

    if test $_flag_single
        set _flag_single --single
    else
        set _flag_single = ""
    end

    if test $_flag_up
        speedtest-cli --no-download --simple $_flag_single
    else if test $_flag_down
        speedtest-cli --no-upload --simple $_flag_single
    else
        speedtest-cli --single --simple $_flag_single
    end
end


# ------------------ PATH ------------------ #
export PATH="$HOME/.poetry/bin:$PATH"
alias poetry="python3 $HOME/.poetry/bin/poetry"

# ------------------ ALIAS ------------------ #
alias py2="python"
alias py="python3"

# ----------------- MACOS SPECIFIC ---------------- #
if [ (uname) = "Darwin" ] 
    # TIME MACHINE
    function TimeMachine
        set opt (math abs\((math (sysctl -n debug.lowpri_throttle_enabled) - 1)\))
        set phase (tmutil currentphase)

        argparse --name=TimeMachine o/optimize p/phase m/manual -- $argv

        if test $_flag_optimize
            set optChange (sudo sysctl -n debug.lowpri_throttle_enabled=$opt)
        end

        if test $_flag_phase
            set optChange (sudo sysctl -n debug.lowpri_throttle_enabled=$opt)
        end

        if test $_flag_manual
            echo "Starting Backup"
            sudo tmutil startbackup --auto
        end

        if test $optChange
            echo "OPTIMIZATION:" (math abs\((math $opt - 1)\)) "->" $opt
        else
            echo "OPTIMIZATION:" $opt
        end

        echo "BACKUP PHASE:" $phase
    end

    # TM Alias
    alias tm="TimeMachine"
end


# ----------------- MULTI-BOOT ---------------- #
if [ (uname) = "Linux" ]
    function multiboot
        set _flag_verbose 0

        # Parse Additional Arguments
        argparse 'v/verbose' -- $argv

        # get OS from argv
        switch (string upper $argv[1])
            case "WIN*"
                set os "Windows 10"
            case "ARCH"
                set os "Arch Linux"
            case "FED*"
                set os "Fedora Server"
        end
        
        
        # IF os variable is empty exit
        if test "$os" = ""
            echo "No Valid OS Provided. exiting ..."
            return
        end

        # Test current os to determine correct reboot command
        if test $_flag_verbose; echo "[VERBOSE] Current OS is: " (uname); end
        switch (uname)
            case "Linux"
                if type -q grub-reboot
                    if test $_flag_verbose; echo "[VERBOSE] using 'grub-reboot' command"; end
                    set cmd "grub-reboot"
                else if type -q grub2-reboot
                    if test $_flag_verbose; echo "[VERBOSE] using 'grub2-reboot' command"; end
                    set cmd "grub2-reboot"
                end
            case "Windows"
                echo "Not Implemented"
                return
        end

        set result (bash -c "sudo $cmd '$os'")

        echo "Booting into '$os' ..."
        sudo reboot
    end
end

function root
    if test (id -u) -eq 0
        echo root
    else
        echo not root
    end
end
export PATH="/usr/local/opt/openjdk/bin:$PATH"
