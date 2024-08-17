set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# Folders
alias ls "eza -la --icons --color=always --group-directories-first"
alias lst "eza -la --icons --color=always --group-directories-first --tree"
alias la "eza -A --icons --color=always --group-directories-first"
alias lt "eza -aT --color=always --group-directories-first"
alias ll="eza -l --color=always --group-directories-first"
alias l. "eza -a | egrep '^\.'"

# Shortcuts
alias g git
alias h navi
alias rr ranger
alias df duf
alias ps procs
alias cat bat
alias grep rg
alias tt "gio trash"
alias history "history | nl"
alias htop bpytop
alias cat bat
alias neofetch "neofetch | lolcat"

# Colorize grep output (good for log files)
alias grep "grep --color=auto"
alias egrep "egrep --color=auto"
alias fgrep "fgrep --color=auto"

# pacman-mirrors
# alias mirrors="sudo sudo pacman-mirrors --fasttrack 30"

# get fastest mirrors
alias mirror "sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord "sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors "sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora "sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# pacman and yay
alias pacsyu "sudo pacman -Syyu" # update only standard pkgs
alias yaysua "yay -Sua --noconfirm" # update only AUR pkgs (yay)
alias yaysyu "yay -Syyu" # update standard pkgs and AUR pkgs (yay)
alias parsua "paru -Sua --noconfirm" # update only AUR pkgs (paru)
alias parsyu "paru -Syu --noconfirm"

# get error messages from journalctl
alias jctl "journalctl -p 5 -xb"

# intellij
alias killws "kill -9 $(pgrep -f storm)"
alias killidea "kill -9 $(ps aux | grep intellij | awk '{print $2}')"
alias toolbox "~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox"

command -qv nvim && alias vim nvim

set -gx EDITOR nvim
set -gx ALTERNATE_EDITOR ""
set -gx VISUAL nvim
set -gx LEDGER_FILE "~/Documents/finances/journal-file.journal"

set -gx NODE_OPTIONS "--max-old-space-size=16384"

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Cutom lazygit config PATH
set -Ux XDG_CONFIG_HOME $HOME/.config

cd
check_directory_for_new_repository

function cd -w='cd'
    builtin cd $argv || return
    check_directory_for_new_repository
end

function check_directory_for_new_repository
    set current_repository (git rev-parse --show-toplevel 2> /dev/null)
    if [ "$current_repository" ] && [ "$current_repository" != "$last_repository" ]
        onefetch
    end
    set -gx last_repository $current_repository
end

function fish_greeting
    colorscript --random
end

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
    status --is-command-substitution; and return

    if test -f .nvmrc; and test -r .nvmrc
        nvm use
    else if test -f package.json; and test -r package.json
        set -l NODE $(jq -r '.engines.node | select(.!=null)' package.json )
        set -l VER (string match -r '[0-9]+(.[0-9]+)+(.[0-9]+)+' $NODE)

        nvm install $VER
    else
    end
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_vi_key_bindings
