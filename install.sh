#!/bin/bash
#for cachyos
# Exit immediately if a command exits with a non-zero status
set -e

#polychromatic, may need reboot after
sudo pacman -S --needed --noconfirm yay
yay -S --needed --noconfirm polychromatic
sudo gpasswd -a $USER openrazer

#one line packages
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
sudo ufw enable

notify-send -i system-software-update "Reboot Required" "Please restart your computer to finish applying updates."
