# TODO

### NetBSD 10 things

`nb boot netbsd 9 foo`
Fetch binary sets, shut down
`cp var/disks/netbsd9-foo.qcow2 var/disks/netbsd10-foo.qcow2`
`git mv etc/nbvm-netbsd9-foo etc/nbvm-netbsd10-foo`
`vi etc/nbvm-netbsd10-foo`
`nb boot netbsd 10 foo`
Install modules, kernel, maybe bootblocks
Reboot into 10 kernel
`hostname=netbsd10-foo`
`dhcpcd_flags="${dhcpcd_flags} --waitip=4"`
`rm -rf /stand/*/9.*`
`chsh toor` (to `/rescue/sh`)
`vipw` (for the `_dhcpcd` user to take)
Reboot into full 10.0 and run `sysinst` from in there, for good measure
`rm var/disks/netbsd9-foo.qcow2`

-----

### 0. In-VM updates in progress
```
( cd ~/bin && rm make pkgbuild qemu-* )
( cd /etc/pkg \
    && sudo rm -f pkgbuild-shared.mk.conf \
    && sudo ln -s ~schmonz/trees/nbvm/etc/nbpkg-shared.mk.conf . \
    && sudo vi /etc/pkg/mk.conf )
( cd ~/trees/nbvm && make )

hostname

cat /etc/pkg/mk.conf

( cd security/openssl && make package )
for i in libfetch pkg_install; do ( cd */$i && make PKG_OPTIONS.libfetch=-openssl replace clean ); done
( cd security/openssl && make replace clean )
for i in libfetch fetch pkg_install; do ( cd */$i && make replace clean ); done
pkg_rolling-replace -suv

pkg_delete py310-\* python310
pkg_delete py39-\* python39
```

-----

### 1. Prepare for OS install

- Create `etc/nbvm-netbsd9-mac68k` with values from:
    - `qemu-port-allocate`
    - `qemu-fqdn2mac netbsd9-mac68k.pet-power-plant.local`
    - `qemu-disk-create ~/trees/nbvm/var/disks/netbsd9-mac68k.qcow2`
- `nb boot netbsd 9 mac68k -cdrom /path/to/iso`
    - Boot installer serially!
        - Rocky Linux e.g.: up-arrow, Tab, remove `quiet`, manually type `inst.text console=ttyS0,115200`
        - Ubuntu just works

### 2. Clean up after install

- Remove bootloader timeout:
    - Rocky Linux e.g.: `GRUB_TIMEOUT=0` in `/etc/default/grub`, then `grub2-mkconfig -o /boot/grub2/grub.cfg`
- Remove "activate the web console" message on Red Hats:
	- `dnf remove cockpit-ws`
- Permit `~/.ssh/authorized_keys` to be a symlink:
    - Red Hats: `sudo setsebool -P use_nfs_home_dirs 1`
    - Tribblix: append `StrictModes no` to `/etc/sshd/sshd_config`
- `nb sh netbsd 9 mac68k`
- `dnf update` or what have you
- `sudo locale-gen en_US.UTF-8` on Ubuntu (and maybe Debian)
- passwordless `sudo` to be able to do that
    - and `secure_path` will need `/opt/pkg/sbin:/opt/pkg/bin`

### 3. Install prerequisite native packages

```sh
$ sudo apk add nfs-utils gcc g++ procps coreutils linux-headers  # Alpine
$ sudo pacman -S nfs-utils gcc inetutils                         # Arch
$ sudo apt install nfs-common gcc g++                            # Debian
$ sudo dnf install nfs-utils gcc gcc-c++ redhat-lsb-core         # Red Hat
$ sudo pkg install gcc-11                                        # Solaris 11
$ sudo xbps-install curl                                         # Void
```

### 4. Bootstrap pkgsrc

Add NFS entry to `/etc/*fstab`, for instance (from Rocky Linux):
```txt
10.0.2.2:/Users/schmonz/trees	/home/schmonz/trees	nfs	rw,auto,noatime,nolock,bg,nfsvers=3,tcp,actimeo=1800	0 0
```

```sh
$ mkdir ~/trees
$ sudo mount ~schmonz/trees
$ sudo ~schmonz/trees/nbvm/bin/nbpkg bootstrap
```

### 5. Configure environment

```sh
$ mv -f .bashrc .bashrc.netbsd10.orig
$ mv -f .bash_profile .bash_profile.netbsd10.orig
$ mv -f .profile .profile.netbsd10.orig
$ cd ~/trees/dotfiles && /opt/pkg/bin/bmake dotfiles
$ mkdir -p ~/.vim && ln -s ~/trees/vimbundle ~/.vim/bundle
$ . ~/.profile
$ bmake; man bmake
$ cd ~/trees/nbvm && bmake
```

### 6. Build my dev tools

```sh
$ cd ~/trees/pkgsrc-cvs/pkgtools/shlock && msv NBPKG_PLATFORM
$ make install clean
$ cd ../../security/sudo && make install clean
$ sudo pkg_admin fetch-pkg-vulnerabilities
$ cd ../../shells/bash && make install clean
$ chsh   # or passwd -e on Solaris
$ cd pkgtools/pkg_rolling-replace && mic
$ cd net/fetch && mic   # mozilla-rootcerts install here, if needed
$ nbpkg mancompress
$ cd meta-pkgs/pkg_developer && mic
$ nbpkg moretools
```

### 7. Start tracking `/etc/pkg`

```sh
$ cd sysutils/etckeeper && mic
$ sudo etckeeper init && sudo etckeeper commit -m 'Initial commit.'
$ ( cd /etc/pkg && sudo git remote add origin ~schmonz/trees/buildvm-etc.git && sudo git branch -M $PLATFORM && sudo git gc && sudo git push -u origin HEAD )
```

### 8. Build my packages

```sh
$ cd meta-pkgs/qmail-server && mic
$ cd www/ikiwiki && mic
$ sudo etckeeper commit -m 'My most important stuff works.'
$ cd pkgtools/pkg_comp && mic
$ sudo etckeeper commit -m 'My weekly server rebuilds might work.'
```

### 9. Rebuild with a single compiler

When `nbpkg listcompilers` outputs two or more lines, some packages could not be built with the system compiler.
That's good: it means most packages have been exercised against the system compiler _and_ pkgsrc automatically handled the other cases as well.

Now let's exercise all packages against the _newest_ compiler currently in use.
For instance, if it's pkgsrc `gcc-10.5.0`, add these lines to `/etc/pkg/mk.conf`:

```make
PKGSRC_COMPILER=        gcc
GCC_REQD=               10.5.0
USE_PKGSRC_GCC=         yes
USE_PKGSRC_GCC_RUNTIME= yes
```

Rebuild all installed packages that had _not_ been built with `gcc-10.5.0`:

```sh
$ for i in $(pkg_info | awk '{print $1}'); do j=$(pkg_info -Q CC_VERSION $i); [ "$j" = "gcc-10.5.0" ] || echo $i; done | grep -v ^gcc10- | sudo xargs pkg_admin set rebuild=YES
$ pkg_rolling-replace -sv
```

Validate: does `nbpkg listcompilers` now output only one line?

-----

## Improvements

- Control image sizes:
    - Guests: TRIM, or else automate `nbvm zerofreespace`
        - Linux: `fstrim -av`
        - NetBSD: experimental `discard` mount option, looks like a nope
    - Hosts:
        - `qemu-img convert -O qcow2 disk.qcow2 disk_notasbig.qcow2`
        - `qemu-img convert -O qcow2 -c disk.qcow2 disk_compressed.qcow2`
- Script this bootstrap process (must be easy to resume after failure)
- Start all VMs on host boot (maybe with `s6-svscan`)
- Automate a `tmux` session with windows for all of them
- Automate "run this command on all VMs" (to build-test packages before commit)
- Extend `rc.d-boot`:
    - Alpine
    - Void
- Convert `nbpkg moretools` to a (perhaps ephemeral) meta-package
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
