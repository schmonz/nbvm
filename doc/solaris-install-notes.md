## Solaris 11

<https://alexstram.com/wordpress/index.php/2020/12/26/getting-solaris-11-3-x86-to-output-to-serial-console/>

<https://firstboot.blogspot.com/2012/10/solaris-boot-in-verbose.html>

### 1. Get running

download VirtualBox Solaris 11 image
`tar -zxf *.ova`
`qemu-img` convert to qcow2
boot with `-drive if=ide`, `-nic model=e1000` (for now)
follow all them setup prompts

### 2. Get in

ssh in (and then `ssh-copy-id`, and re-ssh with that key)
```sh
sudo -s
sed -e 's| ALL$| NOPASSWD: ALL|' < /etc/sudoers.d/svc-system-config-user > /etc/sudoers.d/svc-system-config-user.tmp
mv /etc/sudoers.d/svc-system-config-user.tmp /etc/sudoers.d/svc-system-config-user
pkgrm SUNWvboxguest
svcadm disable application/graphical-login/gdm:default
```

### 3. Verbose serial console

```sh
bootadm set-menu console=serial serial_params=0,115200,8,n,1
bootadm change-entry -i 0 'kargs=-B console=ttya -v -m verbose'
eeprom console="ttya"
eeprom ttya-mode="115200,8,n,1,-"
bootadm list-menu
bootadm remove-entry -i 1
shutdown -y -i 5 -g 0
```
add back -nographic

### 4. Update

```sh
pkg uninstall webui-jet webui-server rad-webuiprefs
pkg uninstall nvidia
reboot
beadm rename solaris solaris-with-nvidia
pkg update --accept
shutdown -y -i 5 -g 0
```

change run script to `-drive if=virtio`, `-nic model=virtio`
boot, wait for inconsistencies to be self-repaired via some auto-reboots
```sh
beadm destroy solaris-with-nvidia
beadm destroy solaris-before-update
vi /etc/vfstab       # add entry for NFS goodies
svcadm enable -r nfs/client
```

### 5. Expand disk

```sh
shutdown -y -i 5 -g 0
qemu-img resize solaris-x86.qcow2 60G
zpool set autoexpand=on rpool
```

XXX grub countdown 5 seconds (not 30)

XXX re-add users and home dirs

### 6. Try to cull packages

I want to put together a list of packages to remove that _doesn't_ remove packages needed for basic console and SSH operation. So far my attempts always produce a list that would remove way too much stuff.

```sh
X11_PACKAGES=$(pkg list 'x11/*' | awk '{print $1}' | grep -v '^NAME$' | grep -v '/libx11$' | grep -v '/libxau$' | grep -v '/x11-protocols$' | grep -v '/libxext$' | grep -v '/libxscrnsaver$' | grep -v '/libxevie$' | grep -v '/libxcb$' | grep -v '/libxdmcp$' | grep -v '/libpthread-stubs$')
DESKTOP_PACKAGES=$(pkg list 'desktop/*' | awk '{print $1}' | grep -v '^NAME$' | grep -v '/desktop-file-utils$)
pkg uninstall gdm gnome-terminal 'gnome/*' 'library/gnome/*' ${DESKTOP_PACKAGES} 'image/*' 'library/desktop/*' library/glib-networking 'communication/im/*' 'editor/gedit*' editor/gvim editor/nano 'library/graphics/*' 'mail/thunderbird*' 'print/*' os-welcome ibus firefox ${X11_PACKAGES} jre-8 xterm ogl-select desktop-cache xload brltty groff cups-libs freetype-2 pulseaudio desktop-startup tk-8  'library/python/pygobject-3-*' ddu pygobject-27 firefox-bookmarks libspectre luit python-imaging-27 tkinter-27 tkinter-34 python-34
aalib 'library/audio/*' consolekit dbus-x11 fbconsole libgtop 'library/python/pygobject-3-*' rad-java dynamic-resource-pools lcms2 glib2
```
