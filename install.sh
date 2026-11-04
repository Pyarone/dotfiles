#!/bin/bash
#for cachyos

#polychromatic, may need reboot after
sudo pacman -Sy --needed --noconfirm yay
yay -S --needed --noconfirm polychromatic
sudo gpasswd -a $USER openrazer

#one line packages
sudo pacman -S --needed --noconfirm git
sudo pacman -S --needed --noconfirm wl-clipboard
sudo pacman -S --needed --noconfirm audacity
sudo pacman -S --needed --noconfirm obs-studio
sudo pacman -S --needed --noconfirm firefox
sudo pacman -S --needed --noconfirm brave-bin
xdg-settings set default-web-browser firefox.desktop
sudo pacman -S --needed --noconfirm discord
sudo pacman -S --needed --noconfirm btop
sudo pacman -S --needed --noconfirm amdgpu_top
sudo pacman -S --needed --noconfirm vlc
sudo pacman -S --needed --noconfirm tailscale
sudo systemctl enable --now tailscaled
sudo pacman -S --needed --noconfirm isoimagewriter
#add the cachyos gaming meta but skip the app package and just get the ones i want
sudo pacman -S --needed --noconfirm cachyos-gaming-meta
sudo pacman -S --needed --noconfirm faugus-launcher lutris steam wqy-zenhei

#remember to start steam at some point to finish its installation

#samba
sudo pacman -S --needed --noconfirm samba cachyos-samba-settings
sudo pacman -S --needed --noconfirm kdenetwork-filesharing
#sudo ufw default deny incoming
#sudo ufw default allow outgoing
sudo ufw allow in on tailscale0 to any port 445 proto tcp
sudo ufw deny in to any port 445 proto tcp
sudo ufw allow in on tailscale0 to any port 139 proto tcp
sudo ufw deny in to any port 139 proto tcp
sudo ufw --force enable

notify-send -i system-software-update "Reboot Required" "Please restart your computer to finish applying updates."

#git stuff

# Check if the private key file already exists
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "Generating a new SSH key..."
    # -N "" creates it with no passphrase, -f specifies the path
    ssh-keygen -t ed25519 -C "pyarone@gmail.com" -N "" -f "$HOME/.ssh/id_ed25519"

    # Start the ssh-agent in the background
    #update: gemini is now saying the following lines aren't needed in modern kde
    #eval "$(ssh-agent -s)"
    # Add your newly created SSH key to the agent
    #ssh-add ~/.ssh/id_ed25519
else
    echo "SSH key already exists. Skipping generation."
fi

# Check if we can already authenticate with GitHub
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "--- ACTION REQUIRED ---"
    echo "Your public SSH key is printed below and copied to your clipboard:"
    cat "$HOME/.ssh/id_ed25519.pub"

    # Try to copy to clipboard automatically depending on the display server
    if command -v wl-copy &> /dev/null; then
        cat "$HOME/.ssh/id_ed25519.pub" | wl-copy
    elif command -v xclip &> /dev/null; then
        cat "$HOME/.ssh/id_ed25519.pub" | xclip -sel clip
    fi

    echo ""
    echo "Log into GitHub in your web browser."
    echo "In the top-right corner, click your profile photo, then select Settings."
    echo "In the left sidebar, click SSH and GPG keys."
    echo "Click the green New SSH key button."
    echo "Give it a descriptive title (e.g., "z370-cachy")."
    echo "In the Key type field, leave it as Authentication Key."
    echo "Paste your copied key into the Key text box."
    echo "Click Add SSH key (you may be asked to enter your GitHub password one last time to confirm)."

    # Pause the script until the user hits Enter
    read -r -p "Press [Enter] once you have added the key to GitHub to continue..."

    # Test the connection manually. If it fails, stop the script explicitly!
    if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "❌ Error: Still unable to authenticate with GitHub. Exiting script."
        exit 1
    fi
fi

#checkout repo if not exists
if [ ! -d "$HOME/.cfg/" ]; then
    echo "Cloning dotfiles repository..."
    # Clone the bare repository
    git clone --bare git@github.com:Pyarone/dotfiles.git $HOME/.cfg/


fi

#this should get the list of files that conflict from git and use that list to move all of those conflicting files into a backup folder
mkdir -p ~/.dotfiles-backup

# Check out files, and if conflicts exist, back them up while preserving directory structure
if ! /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout; then
    echo "Backing up pre-existing conflicting files..."
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | while read -r file; do
        mkdir -p ~/.dotfiles-backup/$(dirname "$file")
        mv "$file" ~/.dotfiles-backup/"$file"
    done

    # Retry checkout after backing up
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
fi

# Hide untracked files so git status doesn't list your whole home directory
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no



