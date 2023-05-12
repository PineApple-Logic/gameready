#!/usr/bin/env bash
# shellcheck disable=SC2140,SC2086

# COLOR VARIABLES
RED="\e[31m"
ENDCOLOR="\e[0m"

# SHOW INITIAL DIALOGS
zenity --info --text="Script made by Nayam Amarshe for the Lunix YouTube channel" --no-wrap
zenity --warning --width 300 --title="Before Starting the Installation" --text="You may see a text asking for your password, just enter your password in the terminal. The password is for installing system libraries, so root access is required by GameReady. When you enter your password, do not worry if it doesn't show you what you typed, it's totally normal."

# INITIALIZING
sudo apt update && sudo apt upgrade
sudo apt install nala -y


# INSTALL WINE
echo -e "\n\n${RED}<-- Installing WINE -->${ENDCOLOR}"
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

# REMOVE PREVIOUS WINE PPA IF PRESENT
sudo rm /etc/apt/sources.list.d/winehq*

# GET UBUNTU VERSION
ubuntuVersion=$(lsb_release -sc)
sudo wget -nc -P /etc/apt/sources.list.d/ "https://dl.winehq.org/wine-builds/ubuntu/dists/${ubuntuVersion}/winehq-${ubuntuVersion}.sources"
sudo nala -y update
sudo nala install -y --install-recommends winehq-stable

# INSTALL WINETRICKS
echo -e "\n\n${RED}<-- Installing Winetricks -->${ENDCOLOR}"
cd || {
    echo "Failed at command cd"
    exit 1
}
sudo nala install -y winetricks

# WINETRICS SELF UPDATE
zenity --warning --width 300 --title="Winetricks Self Update" --text="Winetricks is now installed but to keep it on latest version at all times,\\n we'll ask Winetricks to self-update. Just press Y and press enter."
sudo winetricks --self-update

# INSTALL LUTRIS
echo -e "\n\n${RED}<-- Installing Lutris -->${ENDCOLOR}"
sudo add-apt-repository -y ppa:lutris-team/lutris
sudo nala -y update
sudo nala -y install lutris

# INSTALL GAMEMODE
echo -e "\n\n${RED}<-- Installing Gamemode -->${ENDCOLOR}"
sudo nala install gamemode
sudo nala isntal gamemode:i386

# INSTALL XANMOD KERNEL
if zenity --question --width 300 --title="Install Xanmod Kernel?" --text="Your current kernel is $(uname -r).\\nWe're going to install Xanmod kernel next, Xanmod is for enabling extra performance patches for kernels and this step is required for kernels below v5.16.\\n\\nDo you want to install Xanmod?"; then
    {
        echo -e "\n\n${RED}<-- Installing Xanmod Kernel -->${ENDCOLOR}"
        echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
        wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
        sudo nala update && sudo nala install linux-xanmod -y
        zenity --info --width 200 --title="Success" --text="Xanmod kernel installed! Make sure to reboot after all the script finishes its work."
    }
fi

# INSTALL WINETRICKS DEPENDENCIES
# SET WINDOWS VERSION
winetricks win10

zenity --warning --title="Alright Listen Up" --width 300 --text="Now we're going to install dependencies for WINE like DirectX, Visual C++, DotNet and more.\\n Winetricks will try to install these dependencies for you, so it'll take some time.\\ nDo not panic if you don't receive visual feedback, it'll take time."
echo -e "\n\n${RED}<-- Installing Important WINE Helpers -->${ENDCOLOR}"
winetricks -q -v d3dx10 d3dx9 dotnet35 dotnet40 dotnet45 dotnet48 dxvk vcrun2008 vcrun2010 vcrun2012 vcrun2019 vcrun6sp6

zenity --info --title="Success" --text="All done! Enjoy!"
