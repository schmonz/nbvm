# TODO

## macppc

- boot -current GENERIC
- cross-build custom -current with virtio devices
- works?

## After OS install

[ ] Install `sudo` and `etckeeper` ASAP (natively, else post-bootstrap)
[ ] NFS-mount `~schmonz/trees`
    [ ] after `apt install nfs-common` on Debians
[ ] `git push` etckeeper
[ ] As root, run `~schmonz/trees/package-rebuild/bin/pkgsrc-bootstrap`
    [ ] after `apt install gcc g++` on Debian
[ ] As root, `ln -s ~schmonz/trees/package-rebuild/etc/buildvm-mk.shared.conf /etc/pkg`
[ ] Remove nearly everything from `/etc/pkg/mk.conf` (keep `ABI`, `TOOLS_PLATFORM.foo`, `PKGSRC_COMPILER`)
[ ] `visudo` to make it passwordless
[ ] Add `/opt/pkg/{s,}bin` to `PATH`
    [ ] And possibly `/opt/pkg/man` to `MANPATH`
[ ] Adjust `CDPATH`
    [ ] and whatever bash setting lets ne up-arrow the rest of a command
    [ ] and shorthand for make show-var
    [ ] `ln -s ~/trees/vimbundle ~/.vim/bundle`
[ ] `cd ~/trees/package-rebuild/bin && bmake pkgsrc`
[ ] `sudo pkg_admin fetch-pkg-vulnerabilities`
[ ] `cd ~/trees/pkgsrc-cvs/pkgtools/shlock`
    [ ] `make show-var VARNAME=BUILDVM_PLATFORM`
    [ ] Install `pkgtools/shlock`
[ ] Install `pkgtools/pkg_rolling-replace`
[ ] `pkgsrc-find-uncompressed-manpages | sudo xargs pkg_admin set rebuild=YES`
    [ ] `pkg_rolling-replace -sv`
[ ] Install `net/fetch`
[ ] Install `security/sudo` and `sysutils/etckeeper` if not already present
[ ] `etckeeper commit -m 'Add XXX to etckeeper.'`
[ ] Install `meta-pkgs/pkg_developer`
[ ] Install other tools: `pkgsrc-postbootstrap-moretools`
[ ] `etckeeper commit -m 'Post-bootstrap-and-tools commit.'`
[ ] Install `meta-pkgs/qmail-server`
[ ] Install `www/ikiwiki`
[ ] Install everything else I'm `MAINTAINER` for
[ ] Try getting a newer compiler from pkgsrc
    [ ] And rebootstrapping with that
[ ] Make sure the whole setup is committed to git
[ ] Once I've bootstrapped many new VMs this way, script it
    [ ] Make sure it's easy to resume from wherever it fails
[ ] Will this host be doing `pkgsrc-target-binary-build`?
    [ ] If so, install `pkgtools/pkg_comp` and `net/rsync`

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
