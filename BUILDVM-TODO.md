# TODO

## macppc

- boot -current GENERIC
- cross-build custom -current with virtio devices
- works?

## After OS install

- [ ] Ensure MAC address is unique
- [ ] Install `sudo`, `etckeeper`, and `git` if natively available (else after bootstrap)
    - [ ] `# visudo` for passwordlessness
- [ ] Get NFS client tools and a compiler
    - [ ] Debians: `# apt install nfs-common gcc g++`
    - [ ] Red Hats: `# yum install nfs-utils gcc gcc-c++ redhat-lsb-core`
    - [ ] Alpine: `# apk add nfs-utils gcc g++ procps coreutils`
    - [ ] Arch: `# pacman -S nfs-utils gcc inetutils`
- [ ] NFS-mount `~schmonz/trees` (borrow `/etc/fstab` entry from a similar system)
- [ ] Push up this etckeeper branch:
    - [ ] `# cd /etc && git branch -M $PLATFORM`
    - [ ] `# git remote add origin /home/schmonz/trees/buildvm-etc.git`
    - [ ] `# git push -u origin HEAD`
- [ ] `# ~schmonz/trees/package-rebuild/bin/pkgbuild-bootstrap`
    - [ ] Follow the directions it gives
- [ ] Install everything else I'm `MAINTAINER` for
- [ ] Try getting a newer compiler from pkgsrc
    - [ ] And rebootstrapping with that
- [ ] Make sure the whole setup is committed to git
- [ ] Once I've bootstrapped many new VMs this way, script it
    - [ ] Make sure it's easy to resume from wherever it fails

## Notes

- Hey, how about full `pbulk` builds?
- Set up `distcc` with build hosts at:
    - Mac Pro x86 running Ubuntu
    - Mac mini x86 running macOS
    - (if those help, awesome, get a Mac Studio)
- Would be awesome to submit a new or updated package for a pre-commit many-platforms build
- Alpine
    - Support `pkgtools/rc.d-boot`
    - `apk update && apk upgrade`
- Void
    - Support `pkgtools/rc.d-boot`
    - automate OS update
        - xbps-install -Su
        - vkpurge rm all
- `pkgbuild-os-update`
- standardize qemu VMs:
    - RAM
    - no sound device
    - no floppy device
    - verbose serial boot
- start them (all?) on host boot
    - first svscan
    - then s6-svscan
