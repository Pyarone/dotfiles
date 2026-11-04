#!/bin/bash
#for cachyos
# Exit immediately if a command exits with a non-zero status
set -e

sudo pacman -S --needed --noconfirm python311
sudo pacman -S --needed --noconfirm ffmpeg
mkdir -p ~/whisperx
cd ~/whisperx
python3.11 -m venv venv
source venv/bin/activate
#source venv/bin/activate.fish
pip install --upgrade pip
pip install whisperx
whisperx --version
deactivate
cd ~
