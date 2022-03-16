# TODO

## macppc

- boot -current GENERIC
- cross-build custom -current with virtio devices
- works?

## After OS install

- [ ] Ensure MAC address is unique
- [ ] On Debians, `# apt install nfs-common gcc g++`
- [ ] Install `sudo` and `etckeeper` if natively available (else after bootstrap)
    - [ ] `# visudo` for passwordlessness
- [ ] NFS-mount `~schmonz/trees` (borrow `/etc/fstab` entry from a similar system)
- [ ] `# cd /etc && git branch -M $PLATFORM && git push -u origin HEAD`
- [ ] `# ~schmonz/trees/package-rebuild/bin/pkgsrc-bootstrap-bootstrap`
    - [ ] Follow the directions it gives
- [ ] Install everything else I'm `MAINTAINER` for
- [ ] Try getting a newer compiler from pkgsrc
    - [ ] And rebootstrapping with that
- [ ] Make sure the whole setup is committed to git
- [ ] Once I've bootstrapped many new VMs this way, script it
    - [ ] Make sure it's easy to resume from wherever it fails

## Notes

- Drop older Ubuntu?
- Hey, how about full `pbulk` builds?
- Ubuntu 21:
    - Fix `mail/libspf2` -- see what Ubuntu's package does?
- Gentoo:
    - several packages (starting with `ncurses`) fail `CHECK_SHLIBS`
- Set up `distcc` with build hosts at:
    - Mac Pro x86 running Ubuntu
    - Mac mini x86 running macOS
    - (if those help, awesome, get an aarch64 Mac mini)
- Would be awesome to submit a new or updated package for a pre-commit many-platforms build
