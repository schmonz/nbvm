# TODO

[x] Install `sudo` and `etckeeper` ASAP (natively, else post-bootstrap)
[x] NFS-mount `~schmonz/trees`
[ ] `git push` etckeeper
[x] As root, run `~schmonz/trees/package-rebuild/bin/pkgsrc-bootstrap`
[x] As root, `ln -s ~schmonz/trees/package-rebuild/etc/buildvm-mk.shared.conf /etc/pkg`
[x] Remove nearly everything from `/etc/pkg/mk.conf` (keep `ABI`, `TOOLS_PLATFORM.foo`, `PKGSRC_COMPILER`)
[x] `visudo` to make it passwordless
[x] Add `/opt/pkg/{s,}bin` to `PATH`
    [x] And possibly `/opt/pkg/man` to `MANPATH`
[ ] Adjust `CDPATH`
    [ ] and whatever bash setting lets ne up-arrow the rest of a command
    [ ] and shorthand for make show-var
    [ ] and symlink .vim into NFS bundles
    [ ] and is there a bash setting for tab-completing symlinks the first time?
[x] `cd ~/trees/package-rebuild/bin && bmake pkgsrc`
[x] `sudo pkg_admin fetch-pkg-vulnerabilities`
[x] Sanity-check `make show-var VARNAME=BUILDVM_PLATFORM`
[x] Install `pkgtools/shlock`
[ ] Install `pkgtools/pkg_rolling-replace`
[x] `pkgsrc-find-uncompressed-manpages | sudo xargs pkg_admin set rebuild=YES`
    [ ] `pkg_rolling-replace -sv`
[ ] Install `net/fetch`
[x] Install `meta-pkgs/pkg_developer`
[x] Install other tools: `pkgsrc-postbootstrap-moretools`
[ ] `etckeeper commit -m 'Post-bootstrap-and-tools commit.'`
[ ] Install `meta-pkgs/qmail-server`
[x] Install `www/ikiwiki`
[ ] Install everything else I'm `MAINTAINER` for
[ ] Try getting a newer compiler from pkgsrc
    [ ] And rebootstrapping with that
[ ] Make sure the whole setup is committed to git
[ ] Once I've bootstrapped many new VMs this way, script it
    [ ] Make sure it's easy to resume from wherever it fails


- Set up `ubuntu20` LTS
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
- Get onto `qemu` or otherwise break my dependency on VirtualBox
    - Maybe someday onto Vagrant
