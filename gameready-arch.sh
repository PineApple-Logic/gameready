#!/bin/bash

# COLOR VARIABLES
RED="\e[31m"
ENDCOLOR="\e[0m"

# CHECK IF ZENITY IS INSTALLED
package="zenity";
check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
if [ -n "${check}" ] ; then
    echo "${package} is installed";
    elif [ -z "${check}" ] ; then
    sudo pacman -Syu --noconfirm zenity
fi;

# SHOW INITIAL DIALOGS
zenity --info --text="Script made by Nayam Amarshe for the Lunix YouTube channel" --no-wrap
zenity --warning --width 300 --title="Before Starting the Installation" --text="You may see a text asking for your password, just enter your password in the terminal. The password is for installing system libraries, so root access is required by GameReady. When you enter your password, do not worry if it doesn't show you what you typed, it's totally normal."

# ENABLE PARALLEL DOWNLOADS
sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 10/" /etc/pacman.conf

# INSTALL PARU
echo -e "\n\n${RED}<-- Installing PARU -->${ENDCOLOR}"
sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin || {
    echo "Failed at command cd paru"
    exit 1
}
makepkg --noconfirm -si
cd .. || {
    echo "Failed at command cd in paru"
    exit 1
}
rm -rf paru-bin

# INSTALL WINE
echo -e "\n\n${RED}<-- Installing WINE -->${ENDCOLOR}"
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
paru -S --noconfirm wine wine-mono

# INSTALL WINETRICKS
echo -e "\n\n${RED}<-- Installing Winetricks -->${ENDCOLOR}"
paru -S --noconfirm winetricks

# INSTALL LUTRIS
echo -e "\n\n${RED}<-- Installing Lutris -->${ENDCOLOR}"
paru -S --noconfirm lutris

# INSTALL GAMEMODE
echo -e "\n\n${RED}<-- Installing Gamemode -->${ENDCOLOR}"
paru -S --noconfirm gamemode lib32-gamemode

# INSTALL XANMOD KERNEL
if zenity --question --width 300 --title="Install Xanmod Kernel?" --text="Your current kernel is $(uname -r). THIS STEP IS TOTALLY OPTIONAL! We're going to install Xanmod kernel next, Xanmod is for enabling extra performance patches for kernels. Do you want to install Xanmod?"; then
    {
        echo -e "\n\n${RED}<-- Installing Xanmod Kernel -->${ENDCOLOR}"
        sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
        sudo pacman-key --lsign-key FBA220DFC880C036
        sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
        sudo echo "[chaotic-aur]" >> /etc/pacman.conf
        sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
        sudo pacman -Syu --noconfirm
        sudo pacman -S linux-xanmod-edge linux-xanmod-edge-headers --noconfirm
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        zenity --info --width 200 --title="Success" --text="Xanmod kernel installed!"
    }
fi

# INSTALL WINETRICKS DEPENDENCIES
zenity --warning --title="Alright Listen Up" --width 300 --text="Now we're going to install dependencies for WINE like DirectX, Visual C++, DotNet and more. Winetricks will try to install these dependencies for you, so it'll take some time. Do not panic if you don't receive visual feedback, it'll take time."

echo -e "\n\n${RED}<-- Installing Important WINE Helpers -->${ENDCOLOR}"
winetricks -q -v d3dx10 d3dx9 dotnet35 dotnet40 dotnet45 dotnet48 dxvk vcrun2008 vcrun2010 vcrun2012 vcrun2019 vcrun6sp6

zenity --info --title="Success" --text="All done! Enjoy!"
