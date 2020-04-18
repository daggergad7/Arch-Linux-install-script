set -e

numberofcores=$(grep -c ^processor /proc/cpuinfo)

if [ $numberofcores -gt 1 ]
then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
else
        echo "No change."
fi


echo "################################################################"
echo "###  All cores will be used during building and compression ####"
echo "################################################################"


sudo pacman -Syyu --noconfirm
#bug with deepin-anything - see github
sudo pacman -S linux-headers --noconfirm --needed

#installing displaymanager or login manager
sudo pacman -S --noconfirm --needed lightdm
sudo pacman -S --noconfirm --needed arcolinux-lightdm-gtk-greeter arcolinux-lightdm-gtk-greeter-settings
sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git 
#installing desktop environment
sudo pacman -S deepin deepin-extra --noconfirm --needed
#enabling displaymanager or login manager
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target

echo "Changing /etc/lightdm/lightdm.conf to deepin"

sudo sed -i 's/'#user-session=default'/'user-session=deepin'/g' /etc/lightdm/lightdm.conf
sudo sed -i 's/'#greeter-session=example-gtk-gnome'/'greeter-session=lightdm-gtk-greeter'/g' /etc/lightdm/lightdm.conf

#this is here if one decides to reboot after this script then we have a nice wallpaper
sudo pacman -S arcolinux-wallpapers-git --noconfirm --needed
#Remove anything you do not like from the installed applications

#sudo pacman -R ...

sudo pacman -S pulseaudio --noconfirm --needed
sudo pacman -S pulseaudio-alsa --noconfirm --needed
sudo pacman -S pavucontrol  --noconfirm --needed
sudo pacman -S alsa-utils alsa-plugins alsa-lib alsa-firmware --noconfirm --needed
sudo pacman -S gstreamer --noconfirm --needed
sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly --noconfirm --needed
sudo pacman -S volumeicon --noconfirm --needed
sudo pacman -S playerctl --noconfirm --needed

echo "################################################################"
echo "#########   sound software software installed   ################"
echo "################################################################"



echo "Network Discovery"

sudo pacman -S --noconfirm --needed avahi
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service

#shares on a mac
sudo pacman -S --noconfirm --needed nss-mdns

#shares on a linux
sudo pacman -S --noconfirm --needed gvfs-smb

#change nsswitch.conf for access to nas servers
#original line comes from the package filesystem
#hosts: files mymachines myhostname resolve [!UNAVAIL=return] dns
#ArcoLinux line
#hosts: files mymachines resolve [!UNAVAIL=return] mdns dns wins myhostname

#first part
sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf
#last part
sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf
echo "################################################################"
echo "####       network discovery  software installed        ########"
echo "################################################################"


echo "Install tlp for battery life - laptops"

sudo pacman -S --noconfirm --needed tlp
sudo systemctl enable tlp.service
sudo systemctl start tlp.service

echo "################################################################"
echo "####               tlp  software installed              ########"
echo "################################################################"

##################################################################################################################

# software from standard Arch Linux repositories
# Core, Extra, Community, Multilib repositories
echo "Installing category Accessories"

sudo pacman -S --noconfirm --needed catfish
sudo pacman -S --noconfirm --needed cronie
#sudo pacman -S --noconfirm --needed galculator
#sudo pacman -S --noconfirm --needed gnome-screenshot
sudo pacman -S --noconfirm --needed plank
#sudo pacman -S --noconfirm --needed xfburn
sudo pacman -S --noconfirm --needed variety
#sudo pacman -S --noconfirm --needed


echo "Installing category Development"

sudo pacman -S --noconfirm --needed atom
sudo pacman -S --noconfirm --needed geany
sudo pacman -S --noconfirm --needed meld
#sudo pacman -S --noconfirm --needed

echo "Installing category Education"

#sudo pacman -S --noconfirm --needed

echo "Installing category Games"

#sudo pacman -S --noconfirm --needed

echo "Installing category Graphics"

#sudo pacman -S --noconfirm --needed darktable
sudo pacman -S --noconfirm --needed gimp
#sudo pacman -S --noconfirm --needed gnome-font-viewer
#sudo pacman -S --noconfirm --needed gpick
sudo pacman -S --noconfirm --needed inkscape
sudo pacman -S --noconfirm --needed nomacs
#sudo pacman -S --noconfirm --needed pinta
#sudo pacman -S --noconfirm --needed ristretto
#sudo pacman -S --noconfirm --needed

echo "Installing category Internet"

sudo pacman -S --noconfirm --needed chromium
#sudo pacman -S --noconfirm --needed filezilla
sudo pacman -S --noconfirm --needed firefox
#sudo pacman -S --noconfirm --needed hexchat
sudo pacman -S --noconfirm --needed qbittorrent
#sudo pacman -S --noconfirm --needed

echo "Installing category Multimedia"

#sudo pacman -S --noconfirm --needed clementine
#sudo pacman -S --noconfirm --needed deadbeef
#sudo pacman -S --noconfirm --needed mpv
#sudo pacman -S --noconfirm --needed openshot
sudo pacman -S --noconfirm --needed pragha
#sudo pacman -S --noconfirm --needed shotwell
sudo pacman -S --noconfirm --needed simplescreenrecorder
#sudo pacman -S --noconfirm --needed smplayer
sudo pacman -S --noconfirm --needed vlc
#sudo pacman -S --noconfirm --needed

echo "Installing category Office"

sudo pacman -S --noconfirm --needed evince
#sudo pacman -S --noconfirm --needed evolution
#sudo pacman -S --noconfirm --needed geary
#sudo pacman -S --noconfirm --needed libreoffice-fresh
#sudo pacman -S --noconfirm --needed

echo "Installing category Other"

#sudo pacman -S --noconfirm --needed

echo "Installing category System"

sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed accountsservice
#sudo pacman -S --noconfirm --needed archey3
sudo pacman -S --noconfirm --needed baobab
#sudo pacman -S --noconfirm --needed bleachbit
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed dconf-editor
sudo pacman -S --noconfirm --needed dmidecode
sudo pacman -S --noconfirm --needed ffmpegthumbnailer
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed glances
sudo pacman -S --noconfirm --needed gnome-disk-utility
#sudo pacman -S --noconfirm --needed gnome-keyring
#sudo pacman -S --noconfirm --needed gnome-system-monitor
#sudo pacman -S --noconfirm --needed gnome-terminal
#sudo pacman -S --noconfirm --needed gnome-tweak-tool
sudo pacman -S --noconfirm --needed gparted
sudo pacman -S --noconfirm --needed grsync
sudo pacman -S --noconfirm --needed gtk-engine-murrine
sudo pacman -S --noconfirm --needed gvfs gvfs-mtp
sudo pacman -S --noconfirm --needed hardinfo
sudo pacman -S --noconfirm --needed hddtemp
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed kvantum-qt5
sudo pacman -S --noconfirm --needed kvantum-theme-arc
sudo pacman -S --noconfirm --needed lm_sensors
sudo pacman -S --noconfirm --needed lsb-release
sudo pacman -S --noconfirm --needed mlocate
sudo pacman -S --noconfirm --needed net-tools
#sudo pacman -S --noconfirm --needed notify-osd
sudo pacman -S --noconfirm --needed noto-fonts
sudo pacman -S --noconfirm --needed numlockx
#sudo pacman -S --noconfirm --needed polkit-gnome
sudo pacman -S --noconfirm --needed qt5ct
sudo pacman -S --noconfirm --needed sane
sudo pacman -S --noconfirm --needed screenfetch
sudo pacman -S --noconfirm --needed scrot
sudo pacman -S --noconfirm --needed simple-scan
sudo pacman -S --noconfirm --needed sysstat
#sudo pacman -S --noconfirm --needed terminator
sudo pacman -S --noconfirm --needed termite
#sudo pacman -S --noconfirm --needed thunar
#sudo pacman -S --noconfirm --needed thunar-archive-plugin
#sudo pacman -S --noconfirm --needed thunar-volman
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed ttf-droid
sudo pacman -S --noconfirm --needed tumbler
sudo pacman -S --noconfirm --needed vnstat
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed wmctrl
sudo pacman -S --noconfirm --needed unclutter
sudo pacman -S --noconfirm --needed rxvt-unicode
sudo pacman -S --noconfirm --needed urxvt-perls
sudo pacman -S --noconfirm --needed xdg-user-dirs
sudo pacman -S --noconfirm --needed xdo
sudo pacman -S --noconfirm --needed xdotool
#sudo pacman -S --noconfirm --needed zenity
#sudo pacman -S --noconfirm --needed


###############################################################################################

# installation of zippers and unzippers
sudo pacman -S --noconfirm --needed unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller

###############################################################################################


echo "################################################################"
echo "#### Software from standard Arch Linux Repo installed  #########"
echo "################################################################"


echo "Installing category Accessories"

sh AUR/install-conky-lua-archers-v*.sh
sh AUR/install-mintstick-git-v*.sh

echo "Installing category Development"

sh AUR/install-sublime-text-v*.sh


echo "Installing category Internet"


echo "Installing category Multimedia"


echo "Installing category Office"


echo "Installing category Other"


echo "Installing category System"

sh AUR/install-downgrade-v*.sh
sh AUR/install-font-manager-git-v*.sh
sh AUR/install-inxi-v*.sh
sh AUR/install-neofetch-v*.sh
sh AUR/install-numix-circle-icon-theme-git-v*.sh
sh AUR/install-oxy-neon-v*.sh
sh AUR/install-pamac-aur-v*.sh
#sh AUR/install-paper-icon-theme-git-v*.sh
#sh AUR/install-papirus-icon-theme-git-v*.sh
sh AUR/install-sardi-icons-v*.sh
sh AUR/install-sardi-extra-icons-v*.sh\
sh AUR/install-screenkey-git-v*.sh
sh AUR/install-surfn-icons-git-v*.sh
sh AUR/install-the-platinum-searcher-bin-v*.sh
sh AUR/install-ttf-font-awesome-v*.sh
sh AUR/install-ttf-mac-fonts-v*.sh
sh AUR/install-virtualbox-for-linux-v*.sh

# these come always last

sh AUR/install-hardcode-fixer-git-v*.sh
sudo hardcode-fixer

echo "################################################################"
echo "####        Software from AUR Repository installed        ######"
echo "################################################################"



echo "Installing fonts from Arch Linux repo"

sudo pacman -S adobe-source-sans-pro-fonts --noconfirm --needed
sudo pacman -S cantarell-fonts --noconfirm --needed
sudo pacman -S noto-fonts --noconfirm --needed
sudo pacman -S ttf-bitstream-vera --noconfirm --needed
sudo pacman -S ttf-dejavu --noconfirm --needed
sudo pacman -S ttf-droid --noconfirm --needed
sudo pacman -S ttf-hack --noconfirm --needed
sudo pacman -S ttf-inconsolata --noconfirm --needed
sudo pacman -S ttf-liberation --noconfirm --needed
sudo pacman -S ttf-roboto --noconfirm --needed
sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed
sudo pacman -S tamsyn-font --noconfirm --needed

echo "################################################################"
echo "####        Fonts from Arch Linux repo have been installed        ####"
echo "################################################################"


echo "################################################################"
echo "####        Installing fonts for conkies                    ####"
echo "################################################################"

[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"


echo "Copy fonts to .fonts"

cp Personal/settings/fonts/* ~/.fonts/

echo "Building new fonts into the cache files";
echo "Depending on the number of fonts, this may take a while..."
fc-cache -fv ~/.fonts



echo "################################################################"
echo "#########   Fonts have been copied and loaded   ################"
echo "################################################################"


echo "################################################################"
echo "####                ARCOLINUX FOLDER                        ####"
echo "################################################################"
echo

sudo pacman -S arcolinux-arc-themes-nico-git --noconfirm --needed
sudo pacman -S arcolinux-bin-git --noconfirm --needed
#sudo pacman -S arcolinux-common-git --noconfirm --needed
sudo pacman -S arcolinux-conky-collection-git --noconfirm --needed
#sudo pacman -S arcolinux-conky-collection-plasma-git --noconfirm --needed
sudo pacman -S arcolinux-cron-git --noconfirm --needed
#sudo pacman -S arcolinux-docs-git --noconfirm --needed
#sudo pacman -S arcolinux-faces-git --noconfirm --needed
sudo pacman -S arcolinux-fonts-git --noconfirm --needed
sudo pacman -S arcolinux-geany-git --noconfirm --needed
sudo pacman -S arcolinux-hblock-git --noconfirm --needed
sudo pacman -S arcolinux-kvantum-git --noconfirm --needed
#sudo pacman -S arcolinux-kvantum-lxqt-git --noconfirm --needed
#sudo pacman -S arcolinux-kvantum-plasma-git --noconfirm --needed
#sudo pacman -S arcolinux-lightdm-gtk-greeter --noconfirm --needed
#sudo pacman -S arcolinux-lightdm-gtk-greeter-plasma --noconfirm --needed
#sudo pacman -S arcolinux-lightdm-gtk-greeter-settings --noconfirm --needed
#sudo pacman -S arcolinux-local-applications-git --noconfirm --needed
#sudo pacman -S arcolinux-local-xfce4-git --noconfirm --needed
#sudo pacman -S arcolinux-logo-git --noconfirm --needed
#sudo pacman -S arcolinux-lxqt-applications-add-git --noconfirm --needed
#sudo pacman -S arcolinux-lxqt-applications-hide-git --noconfirm --needed
sudo pacman -S arcolinux-mirrorlist-git --noconfirm --needed
sudo pacman -S arcolinux-neofetch-git --noconfirm --needed
sudo pacman -S arcolinux-nitrogen-git --noconfirm --needed
#sudo pacman -S arcolinux-oblogout --noconfirm --needed
#sudo pacman -S arcolinux-oblogout-themes-git --noconfirm --needed
#sudo pacman -S arcolinux-obmenu-generator-git --noconfirm --needed
#sudo pacman -S arcolinux-obmenu-generator-minimal-git --noconfirm --needed
#sudo pacman -S arcolinux-obmenu-generator-xtended-git --noconfirm --needed
#sudo pacman -S arcolinux-openbox-themes-git --noconfirm --needed
sudo pacman -S arcolinux-pipemenus-git --noconfirm --needed
sudo pacman -S arcolinux-plank-git --noconfirm --needed
sudo pacman -S arcolinux-plank-themes-git --noconfirm --needed
#sudo pacman -S arcolinux-polybar-git --noconfirm --needed
sudo pacman -S arcolinux-qt5-git --noconfirm --needed
#sudo pacman -S arcolinux-qt5-plasma-git --noconfirm --needed
#sudo pacman -S arcolinux-rofi-git --noconfirm --needed
#sudo pacman -S arcolinux-rofi-themes-git --noconfirm --needed
sudo pacman -S arcolinux-root-git --noconfirm --needed
#sudo pacman -S arcolinux-slim --noconfirm --needed
#sudo pacman -S arcolinux-slimlock-themes-git --noconfirm --needed
sudo pacman -S arcolinux-system-config-git --noconfirm --needed
sudo pacman -S arcolinux-termite-themes-git --noconfirm --needed
#sudo pacman -S arcolinux-tint2-git --noconfirm --needed
#sudo pacman -S arcolinux-tint2-themes-git --noconfirm --needed
sudo pacman -S arcolinux-tweak-tool-git --noconfirm --needed
sudo pacman -S arcolinux-variety-git --noconfirm --needed
sudo pacman -S arcolinux-wallpapers-git --noconfirm --needed
sudo pacman -S arcolinux-welcome-app-git --noconfirm --needed
#sudo pacman -S arcolinux-wallpapers-lxqt-dual-git --noconfirm --needed
#sudo pacman -S arcolinux-xfce4-panel-profiles-git --noconfirm --needed
#sudo pacman -S arcolinux-xmobar-git --noconfirm --needed


echo "################################################################"
echo "####            ARCOLINUX DESKTOP CONFIG PACKAGES           ####"
echo "################################################################"
echo


#sudo pacman -S arcolinux-awesome-git --noconfirm --needed
#sudo pacman -S arcolinux-bspwm-git --noconfirm --needed
#sudo pacman -S arcolinux-budgie-git --noconfirm --needed
#sudo pacman -S arcolinux-cinnamon-git --noconfirm --needed
sudo pacman -S arcolinux-deepin-git --noconfirm --needed
#sudo pacman -S arcolinux-dwm-git --noconfirm --needed
#sudo pacman -S arcolinux-enlightenment-git --noconfirm --needed
#sudo pacman -S arcolinux-gnome-git --noconfirm --needed
#sudo pacman -S arcolinux-herbstluftwm-git --noconfirm --needed
#sudo pacman -S arcolinux-i3wm-git --noconfirm --needed
#sudo pacman -S arcolinux-jwm-git --noconfirm --needed
#sudo pacman -S arcolinux-lxqt-git --noconfirm --needed
#sudo pacman -S arcolinux-mate-git --noconfirm --needed
#sudo pacman -S arcolinux-openbox-git --noconfirm --needed
#sudo pacman -S arcolinux-openbox-xtended-git --noconfirm --needed
#sudo pacman -S arcolinux-plasma-git --noconfirm --needed
#sudo pacman -S arcolinux-plasma-nemesis-git --noconfirm --needed
#sudo pacman -S arcolinux-qtile-git --noconfirm --needed
sudo pacman -S arcolinux-xfce-git --noconfirm --needed
#sudo pacman -S arcolinux-xmonad-polybar-git --noconfirm --needed
#sudo pacman -S arcolinux-xmonad-xmobar-git --noconfirm --needed

echo "################################################################"
echo "####                ARCOLINUX CONFIG PACKAGES               ####"
echo "################################################################"
echo


#sudo pacman -S arcolinux-config-git --noconfirm --needed
#sudo pacman -S arcolinux-config-awesome-git --noconfirm --needed
#sudo pacman -S arcolinux-config-bspwm-git --noconfirm --needed
#sudo pacman -S arcolinux-config-budgie-git --noconfirm --needed
#sudo pacman -S arcolinux-config-cinnamon-git --noconfirm --needed
sudo pacman -S arcolinux-config-deepin-git --noconfirm --needed
#sudo pacman -S arcolinux-config-dwm-git --noconfirm --needed
#sudo pacman -S arcolinux-config-enlightenment-git --noconfirm --needed
#sudo pacman -S arcolinux-config-gnome-git --noconfirm --needed
#sudo pacman -S arcolinux-config-herbstluftwm-git --noconfirm --needed
#sudo pacman -S arcolinux-config-i3wm-git --noconfirm --needed
#sudo pacman -S arcolinux-config-jwm-git --noconfirm --needed
#sudo pacman -S arcolinux-config-lxqt-git --noconfirm --needed
#sudo pacman -S arcolinux-config-mate-git --noconfirm --needed
#sudo pacman -S arcolinux-config-openbox-git --noconfirm --needed
#sudo pacman -S arcolinux-config-plasma-git --noconfirm --needed
#sudo pacman -S arcolinux-config-plasma-nemesis-git --noconfirm --needed
#sudo pacman -S arcolinux-config-qtile-git --noconfirm --needed
#sudo pacman -S arcolinux-config-xfce-git --noconfirm --needed
#sudo pacman -S arcolinux-config-xmonad-git --noconfirm --needed
#sudo pacman -S arcolinux-config-xtended-git --noconfirm --needed




echo "################################################################"
echo "####                ARCOLINUX DCONF PACKAGES                ####"
echo "################################################################"
echo

#arcolinux dconf per desktop
#sudo pacman -S --noconfirm --needed  arcolinux-awesome-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-bspwm-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-budgie-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-cinnamon-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-dconf-git
sudo pacman -S --noconfirm --needed  arcolinux-deepin-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-dwm-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-enlightenment-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-gnome-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-herbstluftwm-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-i3wm-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-jwm-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-lxqt-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-mate-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-openbox-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-plasma-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-qtile-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-xfce-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-xmonad-dconf-git
#sudo pacman -S --noconfirm --needed  arcolinux-xtended-dconf-git


echo "################################################################"
echo "Copying all files and folders from /etc/skel to ~"
echo "################################################################"
echo
cp -rT /etc/skel ~

echo "################################################################"
echo "####             Software used by ArcoLinux                 ####"
echo "################################################################"

sudo pacman -S --noconfirm --needed telegram-desktop
sudo pacman -S --noconfirm --needed bibata-cursor-theme

echo "################################################################"
echo "####     Software from ArcoLinux 3party Repository installed       ####"
echo "################################################################"
echo

echo "################################################################"
echo "removing all folders and files unnecessary for this dekstop from .config"
echo "################################################################"
echo

echo "################################################################"
echo "removing all folders and files unnecessary for this desktop from .local"
echo "################################################################"
echo

