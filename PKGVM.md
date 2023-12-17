# TODO

### Prepare for OS install

- Create `etc/pkgvm-netbsd9-mac68k` with values from:
    - `qemu-port-allocate`
    - `qemu-fqdn2mac netbsd9-mac68k.pet-power-plant.local`
    - `qemu-disk-create ~/trees/package-builders/var/disks/netbsd9-mac68k.qcow2`
- `pkgvm start netbsd 9 mac68k -cdrom /path/to/iso`
    - Boot installer serially!
        - Rocky Linux e.g.: up-arrow, Tab, remove `quiet`, manually type `inst.text console=ttyS0,115200`

### Clean up after install

- Remove bootloader timeout:
    - Rocky Linux e.g.: `GRUB_TIMEOUT=0` in `/etc/default/grub`, then `grub2-mkconfig -o /boot/grub2/grub.cfg`
- Remove "activate the web console" message on Red Hats:
	- `yum remove cockpit-ws`
- `pkgvm sshid netbsd 9 mac68k`
- `yum update` or what have you
- passwordless `sudo` to be able to do that
    - and `secure_path` will need `/opt/pkg/sbin:/opt/pkg/bin`

### Install prerequisite native packages

```sh
$ sudo apk add nfs-utils gcc g++ procps coreutils linux-headers  # Alpine
$ sudo pacman -S nfs-utils gcc inetutils                         # Arch
$ sudo apt install nfs-common gcc g++                            # Debian
$ sudo yum install nfs-utils gcc gcc-c++ redhat-lsb-core         # Red Hat
$ sudo pkg install gcc-11                                        # Solaris 11
$ sudo xbps-install curl                                         # Void
```

### Bootstrap pkgsrc

Add NFS entry to `/etc/*fstab`, for instance (from Rocky Linux):
```txt
10.0.2.2:/Users/schmonz/trees	/home/schmonz/trees	nfs	rw,auto,noatime,nolock,bg,nfsvers=3,tcp,actimeo=1800	0 0
```

```sh
$ mkdir ~/trees
$ sudo mount ~schmonz/trees
$ sudo ~schmonz/trees/package-builders/bin/pkgbuild bootstrap
```

### Configure environment

```sh
$ mv .bashrc .bashrc.netbsd9.orig
$ mv .bash_profile .bash_profile.netbsd9.orig
$ cd ~/trees/dotfiles && /opt/pkg/bin/bmake dotfiles
$ mkdir -p ~/.vim && ln -s ~/trees/vimbundle ~/.vim/bundle
$ . ~/.profile
$ bmake; man bmake
$ cd ~/trees/package-builders && bmake
```

### Build my pkgsrc dev tools

```sh
$ cd ~/trees/pkgsrc-cvs/pkgtools/shlock && msv PKGBUILD_PLATFORM
$ make install clean
$ cd ../../security/sudo && make install clean
$ sudo pkg_admin fetch-pkg-vulnerabilities
$ cd ../../shells/bash && make install clean
$ chsh   # or passwd -e on Solaris
$ cd pkgtools/pkg_rolling-replace && mic
$ cd net/fetch && mic
$ pkgbuild mancompress
$ cd meta-pkgs/pkg_developer && mic
$ pkgbuild moretools
```

### Start tracking /etc/pkg

```sh
$ cd sysutils/etckeeper && mic
$ sudo etckeeper init && sudo etckeeper commit -m 'Initial commit.'
$ ( cd /etc/pkg && sudo git remote add origin ~schmonz/trees/buildvm-etc.git && sudo git branch -M $PLATFORM && sudo git gc && sudo git push -u origin HEAD )
```

### Build my packages

```sh
$ cd meta-pkgs/qmail-server && mic
$ cd www/ikiwiki && mic
$ sudo etckeeper commit -m 'My most important stuff works.'
$ cd pkgtools/pkg_comp && mic
$ sudo etckeeper commit -m 'My weekly server rebuilds might work.'
```

### Was more than one compiler used?

```sh
$ pkgbuild listcompilers
```

### If so, from now on, build with the newer one

Add to `/etc/pkg/mk.conf`:

```make
PKGSRC_COMPILER=        gcc
GCC_REQD=               10.5.0
USE_PKGSRC_GCC=         yes
USE_PKGSRC_GCC_RUNTIME= yes
```

### Rebuild all packages that had been built with the older one

```sh
$ for i in $(pkg_info | awk '{print $1}'); do j=$(pkg_info -Q CC_VERSION $i); [ "$j" = "gcc-10.5.0" ] || echo $i; done | grep -v ^gcc10- | sudo xargs pkg_admin set rebuild=YES
$ pkg_rolling-replace -sv
```

### Was exactly one compiler used?

```sh
$ pkgbuild listcompilers
```


## Improvements

- Script this bootstrap process (must be easy to resume after failure)
- Start all VMs on host boot (maybe with `s6-svscan`)
- Automate a `tmux` session with windows for all of them (`pkgbuild tmux`)
- Automate "run this command on all VMs" (to build-test packages before commit)
- Automate OS updates (`pkgbuild osupdate`)
    - Alpine: `apk update && apk upgrade`
    - Void: `xbps-install -Su && vkpurge rm all`
- Extend `rc.d-boot`:
    - Alpine
    - Void
- Convert `pkgbuild moretools` to a (perhaps ephemeral) meta-package
- Convert `pkg_add_everything()` to `pkgin`?
- Install everything else I'm MAINTAINER for, as a (perhaps ephemeral) meta-package


## Notes

- Hey, how about full `pbulk` builds?
- Set up `distcc` with build hosts at:
    - Mac Pro x86 running Ubuntu
    - Mac mini x86 running macOS
    - (if those help, awesome, get a Mac Studio)


## Machines sort of in progress

```ssh
Host smartos-x86_64 smartos
  HostName localhost
  Port 4445
  User root

Host osxserver-x86_64 osxserver
  HostName localhost
  Port 4545
  HostKeyAlgorithms +ssh-rsa,ssh-dss

Host osxnew
  HostName localhost
  Port 4547

Host snowleopard-x86_64 snowleopard
  HostName localhost
  Port 4546
```
