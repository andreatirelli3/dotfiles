#!/bin/bash

#============================
# ASCII ART FUNCTION
#============================

show_ascii_art() {
    c6="\e[36m"
    c4="\e[34m"
    reset="\e[0m"
    echo -e "${c6}       /\\"
    echo -e "${c6}      /  \\"
    echo -e "${c6}     /\\   \\"
    echo -e "${c4}    /      \\"
    echo -e "${c4}   /   ,,   \\"
    echo -e "${c4}  /   |  |  -\\"
    echo -e "${c4} /_-''    ''-_\\"
    echo -e "${reset}@andreatirelli3 dotfiles"
}

#============================
# MENU FUNCTION
#============================

show_menu() {
    clear
    show_ascii_art
    echo "1) Run arch script"
    echo "2) Run first system setup script"
    echo "3) Run GNOME setup script"
    echo "4) Run development setup script"
    echo "q) Quit"
    echo -n "Choose an option: "
}

#============================
# MAIN LOGIC
#============================

# Get the absolute directory of the current script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

while true; do
    show_menu
    read -r choice
    case $choice in
        1)
            echo "Running the arch script..."
            if [ -f "$SCRIPT_DIR/arch-installer.sh" ]; then
                bash "$SCRIPT_DIR/arch-installer.sh"
            else
                echo "The arch script was not found."
            fi
            ;;
        2)
            echo "Running first system setup script..."
            if [ -f "$SCRIPT_DIR/env-installer.sh" ]; then
                bash "$SCRIPT_DIR/env-installer.sh"
            else
                echo "The first system setup script was not found."
            fi
            ;;
        3)
            echo "Running the GNOME setup script..."
            if [ -f "$SCRIPT_DIR/gnome-installer.sh" ]; then
                bash "$SCRIPT_DIR/gnome-installer.sh"
            else
                echo "The GNOME setup script was not found."
            fi
            ;;
        4)
            echo "Running the development setup script..."
            if [ -f "$SCRIPT_DIR/dev-installer.sh" ]; then
                bash "$SCRIPT_DIR/dev-installer.sh"
            else
                echo "The development setup script was not found."
            fi
            ;;
        q|Q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo -n "Press Enter to continue..."
    read -r
done
