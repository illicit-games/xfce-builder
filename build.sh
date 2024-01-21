#!/bin/bash

# Working Directories

WORKING="$(pwd)"
SOURCE="igsource"
BUILD="iglive"

# Remove icon cache cleaning hook, create the build staging folder, and cd into it

[[ -f /usr/share/live/build/hooks/normal/9000-remove-gnome-icon-cache.hook.chroot ]] && rm /usr/share/live/build/hooks/normal/9000-remove-gnome-icon-cache.hook.chroot

mkdir $BUILD
cd $BUILD

# Live Build Configuration

lb config --binary-images iso --mode debian --architectures amd64 --linux-flavours amd64 --distribution trixie --archive-areas "main non-free-firmware" --memtest none --updates true --security true --cache true --apt-recommends true --apt-source-archives false --source false --firmware-binary true --firmware-chroot true --win32-loader false --iso-application $BUILD --iso-preparer illicitgames-https://github.com/illicit-games/xfce-builder/ --iso-publisher illicitgames-https://github.com/illicit-games/xfce-builder/ --image-name "$BUILD-$(date -u +"%y%m%d")" --iso-volume "$BUILD-$(date -u +"%y%m%d")" --checksums sha512 --clean --color

# Install Desktop

echo "xfce4-appfinder xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop4 xfwm4 xfce4-whiskermenu-plugin xfce4-power-manager xfce4-power-manager-plugins xfce4-taskmanager xfce4-systemload-plugin xfce4-screenshooter xdm network-manager-gnome network-manager-config-connectivity-debian macchanger pwgen firefox-esr weechat xarchiver p7zip-full gparted" > $WORKING/$BUILD/config/package-lists/desktop.list.chroot

# Install Applications, all of these may be able to be removed using suggsted and recommends. we will see.

echo "apt-transport-https autoconf automake build-essential cifs-utils dbus-user-session dbus-x11 debconf debhelper dh-autoreconf dialog dirmngr dkms dosfstools exfatprogs fakeroot ghostscript gir1.2-ibus-1.0 grub-pc hardinfo haveged ibus ibus-data ibus-gtk ibus-gtk3 iftop im-config iw jfsutils libibus-1.0-5 libxcb-xtest0 linux-headers-amd64 lsb-release lshw menu netcat-openbsd ntfs-3g os-prober pciutils perl policykit-1 squashfs-tools sudo syslinux syslinux-common udisks2 upower x11-common xauth xdg-utils" > $WORKING/$BUILD/config/package-lists/extrapackages.list.chroot


# Install Firmware

echo "atmel-firmware firmware-linux-free firmware-misc-nonfree firmware-amd-graphics firmware-atheros firmware-intel-sound firmware-linux firmware-linux-nonfree firmware-misc-nonfree firmware-realtek firmware-ti-connectivity firmware-sof-signed" > $WORKING/$BUILD/config/package-lists/firmware.list.chroot


# INCLUDE CLAMARES INSTALLER FROM LIVE BUILD
# DEBIAN SALSA LIVE BUILD TEAM

mkdir -p $WORKING/$BUILD/config/includes.chroot/etc/
cp -r $WORKING/$SOURCE/calamares/ $WORKING/$BUILD/config/includes.chroot/etc/
echo "calamares calamares-settings-debian" > $WORKING/$BUILD/config/package-lists/calamares.list.chroot

cp -r $WORKING/$SOURCE/ $WORKING/$BUILD/config/includes.chroot/usr/share/
ln -s /usr/share/$SOURCE $WORKING/$BUILD/config/includes.chroot/etc/skel/$SOURCE


# CREATE DIRECTORIES

mkdir -p $WORKING/$BUILD/config/includes.chroot/usr/local/bin/

# COPYING

cp -r $WORKING/$SOURCE/bootloaders/ $WORKING/$BUILD/config/
cp -r $WORKING/$SOURCE/ $WORKING/$BUILD/config/includes.chroot/usr/share/
ln -s /usr/share/$SOURCE $WORKING/$BUILD/config/includes.chroot/etc/skel/$SOURCE


lb build
