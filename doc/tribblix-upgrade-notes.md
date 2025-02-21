# UPGRADING

<http://tribblix.org/zap-upgrade.html>

    zap refresh
    zap update TRIBzap-upgrade
    zap upgrade list
    zap upgrade $NEWEST
    beadm activate $NEWEST
    init 6

## After

Restore local `/etc` settings:

    vi /etc/inet/hosts /etc/nodename
    beadm mount $PREVIOUS /mnt
    cd /mnt/etc
    cp vfstab profile /etc
    cp ssh/sshd_config /etc/ssh
    beadm unmount $PREVIOUS
    beadm destroy $PREVIOUS
    mount /export/home/schmonz/trees
    . ~/.profile
    nbvm shutdown
