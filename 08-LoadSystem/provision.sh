#!/usr/bin/env bash

#yes | yum install -y vim

oldvgname=$(vgs --rows | grep VG | cut -d ' ' -f4)
newvgname=OTUS

vgrename $oldvgname $newvgname

cp -f /etc/fstab /etc/fstab.backup
cp -f /boot/grub2/grub.cfg /boot/grub2/grub.cfg.backup
#  cp -f /boot/grub2/grub.cfg /boot/grub2/grub.cfg.backup

sed -i "s/$oldvgname/$newvgname/g" /etc/fstab
sed -i "s/$oldvgname/$newvgname/g" /boot/grub2/grub.cfg
#  sed -i "s/$oldvgname/$newvgname/g" /boot/grub2/grub.cfg
#activate the volume group
vgchange -ay
#Change attributes of a logical volume.
lvchange /dev/$newvgname/root --refresh
lvchange /dev/$newvgname/swap --refresh

#Create new initial disk
cp /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.$(date +%m-%d-%H%M%S).bak
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

###################
# 3-rd task
###################

mkdir /usr/lib/dracut/modules.d/01test
cp /home/vagrant/module_setup.sh /usr/lib/dracut/modules.d/01test/module-setup.sh
chmod +x /usr/lib/dracut/modules.d/01test/module-setup.sh
cp /home/vagrant/test.sh /usr/lib/dracut/modules.d/01test/test.sh
chmod +x /usr/lib/dracut/modules.d/01test/test.sh

#Renew the intrd image
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
dracut -f -v


####
#Test by the folowing commad
#lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
#####vgs