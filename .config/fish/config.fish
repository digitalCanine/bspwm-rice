# Disable fish greeting
set -g fish_greeting

# Disable vi mode (removes [I])
fish_default_key_bindings

# Enable truecolor
set -g fish_term24bit 1

## Left prompt: current dir + >>
function fish_prompt
    # Directory (shows ~ or current folder)
    set_color cyan
    echo -n (prompt_pwd) " "

    # Orange >>
    set_color ff8700
    echo -n ">> "

    # Reset
    set_color normal
end

# Right prompt: time
function fish_right_prompt
    set_color 666666
    date "+%H:%M:%S"
    set_color normal
end

# Aliases
alias todo="java /home/carrie/Documents/code/java/todo-cli/src/Main.java"
alias lancer="/home/carrie/Documents/lancer/lancer.sh"
alias cls="clear"
alias g="git"
alias n="nvim"
alias m="micro"
alias react-create="npx create-react-app@5.1.0"
alias hyfetch="hyfetch --ascii-file ~/.config/fastfetch/linuximaginary_small.txt"
alias ls="eza --icons -x"
alias wallupdate="python /home/carrie/.config/meowrch/update_wallpapers.py"
alias update="sudo pacman -Syu & yay -Syu"
alias vpn="/home/carrie/Documents/code/bash/vpn/vpn.sh"

# Startup
if status is-interactive
    fastfetch
end
set -x QT_QPA_PLATFORMTHEME qt5ct
set -x QT_QPA_PLATFORMTHEME qt6ct

gsettings set org.gnome.desktop.interface gtk-theme dc
gsettings set org.gnome.desktop.interface gtk-theme dc
