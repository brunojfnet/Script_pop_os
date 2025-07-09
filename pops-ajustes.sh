#!/usr/bin/bash
# Description: Script para ajustes Pop!_OS 21.04
# Script para uso pessoal com coisas basicas em instalações limpas
# Author: Bruno Rafael
# Date: 2021/10/01

# Verify for sudo/root execution
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute o script como sudo!"
  exit
fi

# Get the Real Username
RUID=$(who | awk 'FNR == 1 {print $1}')

# Translate Real Username to Real User ID
RUSER_UID=$(id -u ${RUID})

read -p "Adicionando Repositorio Notion..."
wget https://notion.davidbailey.codes/notion-linux.list -O /etc/apt/sources.list.d/notion-linux.list

read -p "Iniciar Atualização..."
apt-get update
apt-get upgrade -y
apt-get -f install -y
apt-get dist-upgrade -y

read -p "Iniciar Wine..."
sudo dpkg --add-architecture i386
sudo apt-get update
sudo snap install wine-platform-runtime

read -p "Habilitar snap..."
sudo apt-get install snapd
apt-get update
apt-get upgrade -y
apt-get -f install -y
apt-get dist-upgrade -y

read -p "Pacotes Basicos..."
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

read -p "Instalar Dotnet..."
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

apt-get update
apt-get upgrade -y
apt-get -f install -y
apt-get dist-upgrade -y

read -p "SDK dotnet..."
sudo apt-get update; sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-5.0

read -p "Instalar Runtime Dotnet..."
sudo apt-get update; sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y aspnetcore-runtime-5.0

read -p "Iniciar Atualização..."
apt-get install  notion-desktop  cabextract  ubuntu-restricted-extras  remmina  peek  nodejs  openjdk-11-jre  openjdk-8-jdk  npm  filezilla  p7zip-full  gnome-boxes  docker.io  docker-compose  htop  zenity  ssh-askpass  -y

read -p "Ajustar OpemVPN..."
apt-get install  network-manager-openvpn  network-manager-openvpn-gnome  openvpn-systemd-resolved  -y

read -p "Instalar Google..."
wget --no-check-certificate "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb
dpkg -i chrome.deb
rm -Rf chrome.deb

read -p "Instalar Teawmviewer..."
wget --no-check-certificate "https://download.teamviewer.com/download/linux/version_13x/teamviewer_amd64.deb" -O teamviewer.deb
dpkg -i teamviewer.deb
apt-get -f install -y
rm -Rf teamviewer.deb
rm -Rf /etc/apt/sources.list.d/teamviewer.list
sudo apt-mark hold teamviewer

usermod -aG docker $SUDO_USER
usermod -aG lpadmin $SUDO_USER

read -p "Instalar Fontes..."
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts
sudo -u $SUDO_USER wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | sudo -u $SUDO_USER bash

read -p "Instalar Flatpacks..."
sudo -u $SUDO_USER flatpak update -y --noninteractive
sudo -u $SUDO_USER flatpak install flathub org.flameshot.Flameshot -y --noninteractive
sudo -u $SUDO_USER flatpak install io.dbeaver.DBeaverCommunity -y --noninteractive
sudo -u $SUDO_USER flatpak install com.anydesk.Anydesk -y --noninteractive
sudo -u $SUDO_USER flatpak install com.getpostman.Postman -y --noninteractive
sudo -u $SUDO_USER flatpak install com.spotify.Client -y --noninteractive
sudo -u $SUDO_USER flatpak install org.qbittorrent.qBittorrent -y --noninteractive
sudo -u $SUDO_USER flatpak install com.simplenote.Simplenote -y --noninteractive
sudo -u $SUDO_USER flatpak install org.gimp.GIMP -y --noninteractive
sudo -u $SUDO_USER flatpak install com.obsproject.Studio -y --noninteractive
sudo -u $SUDO_USER flatpak install org.kde.kdenlive -y --noninteractive
sudo -u $SUDO_USER flatpak install com.github.tchx84.Flatseal -y --noninteractive
sudo -u $SUDO_USER flatpak install us.zoom.Zoom -y --noninteractive
sudo -u $SUDO_USER flatpak remove org.kde.Kstyle.Adwaita -y --noninteractive

read -p "Set Google..."
sudo -u $SUDO_USER xdg-settings set default-web-browser google-chrome.desktop

read -p "Set multimonitor..."
sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.mutter workspaces-only-on-primary true

wget --no-check-certificate https://raw.githubusercontent.com/begati/gnome-shortcut-creator/main/gnome-keytool.py -O gnome-keytool.py
sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
sudo -u $SUDO_USER python3 gnome-keytool.py 'Print Screen' 'flatpak run org.flameshot.Flameshot gui' 'Print'
rm -Rf gnome-keytool.py

read -p "Install Rambox..."
sudo snap install rambox

read -p "Install Vlc..."
sudo snap install vlc

read -p "Install Only Office..."
sudo snap install onlyoffice-desktopeditors

read -p "Install Gnome Ajustes..."
wget https://launchpad.net/ubuntu/+archive/primary/+files/gnome-tweak-tool_3.26.2.1-1ubuntu1_all.deb -O gnome-tweak-tool.deb
sudo dpkg -i gnome-tweak-tool.deb
sudo apt-get install -f

apt clean
apt autoremove -y

clear
read -p "Seu computador será reiniciado, pressione qualquer tecla para continuar..." temp </dev/tty
reboot
