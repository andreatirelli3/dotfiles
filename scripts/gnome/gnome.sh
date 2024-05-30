#!/bin/bash

#============================
# DEBUG FUNCTIONS
#============================

# Output debug - success
print_success() {
    local message="$1"
    # Format message with green text.
    echo -e "\e[32m$message\e[0m"
}

# Output debug - error
print_error() {
    local message="$1"
    # Format message with red text.
    echo -e "\e[31m$message\e[0m"
}

# Output debug - info
print_info() {
    local message="$1"
    # Format message with cyan text.
    echo -e "\e[36m$message\e[0m"
}

#============================
# CONFIGURATION FUNCTIONS
#============================

# Audio step
conf_audio() {
  # Change the audio mix step from 5 to 2
  gsettings set org.gnome.settings-daemon.plugins.media-keys volume-step 2
  print_success "[+] Audio step changed from 5 to 2!"
}

# Debloat
debloat_gnome() {
  # Check if there are any packages passed as arguments.
  if [ "$#" -eq 0 ]; then
    print_error "No packages specified to uninstall!"
    return 1  # Do nothing and exit the function.
  fi

  # Use the passed packages list or fallback to the predefined list.
  local packages=("$@")

  # Iterate over the packages and attempt to remove them.
  for package in "${packages[@]}"; do
    print_info "[*] Removing $package ..."
    if sudo pacman -Rcns --noconfirm "$package" &> /dev/null; then
      print_success "[+] $package removed successfully!"
    else
      print_error "[-] $package failed to remove."
    fi
  done
}

# Default application
gnome_app() {
  # Flatpak list
  flatpaks=(
    com.raggesilver.BlackBox           # Terminal
    com.mattjakeman.ExtensionManager   # Extension manager
    com.github.tchx84.Flatseal         # Flatpaks manager
    com.brave.Browser                  # Browser
    org.mozilla.Thunderbird            # Email client
    md.obsidian.Obsidian               # Notes
    org.libreoffice.LibreOffice        # Document office
    net.xmind.XMind                    # Mind maps
    com.obsproject.Studio              # Video recorder
    com.spotify.Client                 # Spotify
    io.github.spacingbat3.webcord      # Discord
    org.kde.kdenlive                   # Video editor
    org.gnome.Loupe                    # Image visualizer
    com.github.rafostar.Clapper        # Video player
    org.telegram.desktop               # Telegram
    org.signal.Signal                  # Signal
    it.mijorus.smile                   # Emoji picker
    org.gnome.Calculator               # Calculator
  )
  
  print_info "Installing flatpaks ..."
  # Install flatpaks
  flatpak install --user -y flathub "${flatpaks[@]}"
  # Clean the installations
  flatpak remove --unused
  print_success "Flatpaks installed!"
  
  # [TODO] - Fedora support
  # [TODO] - Debian support

  # Packages list
  packages=(
    noto-fonts-emoji
    nerd-fonts

    blackbox-terminal
    extension-manager
    brave-bin
    obsidian
    thunderbird
    libreoffice-fresh
    libreoffice-extension-texmaths
    libreoffice-extension-writer2latex
    xmind
    obs-studio
  )
  
  print_info "Installing packages"
  # Install packages
  paru -S --noconfirm "${packages[@]}"
  print_success "Packages installed!"
}

# theming
gnome_theming() {
  # [TODO] - Fedora support
  # [TODO] - Debian support

  # Install the following packages:
  #
  # - morewaita
  # - flat remix
  # - adw-gtk3
  # - bibata cursor
  # - thunderbird libwaita theme
  paru -S --noconfirm morewaita flat-remix adw-gtk3 bibata-cursor-theme-bin
  # Also theme flatpak
  flatpak install --user -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
  git clone https://github.com/rafaelmardojai/thunderbird-gnome-theme
  # Clean the installation
  flatpak remove --unused

  # Enable all the themes
  # gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'
  gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Light"
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' && gsettings set org.gnome.desktop.interface color-scheme 'default'

  print_info "Thunderbird is not installed or neither execture for atleast 1 time, I cloned the repo but install it manually."

  # Clone wallpaper repository
  git clone git@github.com:andreatirelli3/wallpapers.git ~/Immagini/wallpaper
}

# Extensions
gnome_ext() {
  # [TODO] - Fedora support
  # [TODO] - Debian support

  # Install the required packages
  sudo pacman -S --noconfirm jq unzip wget curl

  # Rounded window
  sudo pacman -S --noconfirm nodejs npm gettext just
  git clone https://github.com/flexagoon/rounded-window-corners
  cd rounded-window-corners
  just install
  cd .. && rm -rf rounded-window-corners

  # Unite
  # URL of the zip file
  url="https://github.com/hardpixel/unite-shell/releases/download/v78/unite-shell-v78.zip"
  # Directory to extract the extension
  extension_dir="$HOME/.local/share/gnome-shell/extensions"

  # Create the directory if it doesn't exist
  mkdir -p "$extension_dir"

  # Download the zip file
  curl -sL -o /tmp/unite-shell-v78.zip "$url" || { print_error "Download failed"; exit 1; }

  # Extract the zip file
  unzip -qo /tmp/unite-shell-v78.zip -d "$extension_dir" || { print_error "Extraction failed"; exit 1; }

  # Clean up
  rm /tmp/unite-shell-v78.zip

  # Pop shell
  sudo pacman -S --noconfirm typescript
  git clone https://github.com/pop-os/shell.git
  cd shell
  make local-install || true
  cd ..
  rm -rf shell

  EXT_LIST=(
    blur-my-shell@aunetx                          # Blur
    just-perfection-desktop@just-perfection       # Perfection
    osd-volume-number@deminder                    # OSD Volume
    quick-settings-tweaks@qwreey                  # QS Tweak
    quick-settings-avatar@d-go                    # Avatar qs
    nightthemeswitcher@romainvigier.fr            # Night theme
    custom-accent-colors@demiskp                  # Accent color
    smile-extension@mijorus.it                    # Emoji
    app-hider@lynith.dev                          # App hider
    workspace-switcher-manager@G-dH.github.com    # Workspace switcher
    compact-quick-settings@gnome-shell-extensions.mariospr.org # Compact qs
    Airpod-Battery-Monitor@maniacx.github.com     # AirPods battery
    Bluetooth-Battery-Meter@maniacx.github.com    # Bluetooth battery
    caffeine@patapon.info                         # Caffeine
    logomenu@aryan_k                              # (left) Logo
    window-title-is-back@fthx                     # (left) Window title
    mediacontrols@cliffniff.github.com            # (center) Media player
    clipboard-indicator@tudmotu.com               # (right) Clipboard
    just-another-search-bar@xelad0m               # (right) Search
    IP-Finder@linxgem33.com                       # (right) IP
    arch-update@RaphaelRochet                     # (right) Updates
    extension-list@tu.berry                       # (right) Extension list
    openweather-extension@penguin-teal.github.io  # (right) Weather
    tophat@fflewddur.github.io                    # (right) Resource usage
    appindicatorsupport@rgcjonas.gmail.com        # (right) Sys tray
  )

  GN_CMD_OUTPUT=$(gnome-shell --version)
  GN_SHELL=${GN_CMD_OUTPUT:12:2}

  for i in "${EXT_LIST[@]}"; do
    VERSION_LIST_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq -c '.extensions[] | select(.uuid=="'"${i}"'")') 
    VERSION_TAG=$(echo "$VERSION_LIST_TAG" | jq -r '.shell_version_map | ."'"${GN_SHELL}"'" | ."pk"')
    
    if [ -n "$VERSION_TAG" ]; then
      wget -qO "${i}.zip" "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
      if [ $? -eq 0 ]; then
        gnome-extensions install --force "${i}.zip"
        rm "${i}.zip"
      else
        print_error "Failed to download extension: ${i}"
      fi
    else
      print_warning "No valid version found for extension: ${i}"
    fi
  done

  print_warning "Gnome 4x UI is bugged - Install it manually!"
}

#============================
# MAIN BODY
#============================

# Move to the home directory
cd $HOME

read -p "Do you want to change the audio step from 5 to 2? (y/n): " audio_choice
if [[ "$aur_choice" == "y" || "$aur_choice" == "Y" ]]; then
  conf_audio || print_error "[-] Failed to configure audio step!"
fi

# List of packages to be removed
default_packages=(
  totem
  yelp
  gnome-software
  gnome-tour
  gnome-music
  epiphany
  gnome-maps
  gnome-contacts
  gnome-logs
  gnome-font-viewer
  simple-scan
  orca
  gnome-system-monitor
  gnome-connections
  gnome-characters
  snapshot
  baobab
  gnome-disk-utility
  gnome-text-editor
  gnome-remote-desktop
  gnome-console
  loupe
  gnome-calculator
  gnome-weather
  gnome-clocks
  flatpak
)

read -p "Do you want to remove useless packages? (y/n): " debloat_choice
if [[ "$debloat_choice" == "y" || "$debloat_choice" == "Y" ]]; then
  debloat_gnome || print_error "[-] Failed to remove useless packages!"
fi














# 1. Flatpak configure
read -p "Do you want to configure Flatpak? (y/n): " flatconfig_choice
if [[ "$flatconfig_choice" == "y" || "$flatconfig_choice" == "Y" ]]; then
  print_info "Configuring the Flathub repo for current user ..."
  flatpak_setup
  print_success "Flathub configured correctly!"
fi

# 2. Audio step
read -p "Do you want to change the audio step from 5 to 2? (y/n): " audio_choice
if [[ "$audio_choice" == "y" || "$audio_choice" == "Y" ]]; then
  print_info "Changing audio step from 5 => 2 ..."
  gnome_audio
  print_success "Audio step changed successfully!"
fi

# 3. Debloating
read -p "Do you want to debloat the system? (y/n): " debloat_choice
if [[ "$debloat_choice" == "y" || "$debloat_choice" == "Y" ]]; then
  print_info "Debloating the system ..."
  gnome_debloat
  print_success "System debloated!"
fi

# 4. Default application
read -p "Do you want to install the default applications? (y/n): " app_choice
if [[ "$app_choice" == "y" || "$app_choice" == "Y" ]]; then
  print_info "Installing default application ..."
  gnome_app
  print_success "Default application installed!"
fi

# 5. Personalization
read -p "Do you want theme the system (GTK4/3 Libwaita friendly)? (y/n): " theme_choice
if [[ "$theme_choice" == "y" || "$theme_choice" == "Y" ]]; then
  print_info "Theming the system ..."
  gnome_theming
  print_success "System themed!"
fi

# 6. Extension
read -p "Do you want to install the gnome extensions? (y/n): " ext_choice
if [[ "$ext_choice" == "y" || "$ext_choice" == "Y" ]]; then
  print_info "Installing extensions ..."
  gnome_ext
  print_success "Extensions installed!"
fi
