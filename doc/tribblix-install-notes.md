## Tribblix

post-install:

```sh
cat >> /boot/loader.conf.local <<EOF
console="ttya"
verbose_loading="YES"
autoboot_delay="3"
beastie_disable="YES"
EOF
userdel -r jack
passwd root
useradd -g staff -m schmonz
zap install-overlay networked-system develop
echo tribblix.pet-power-plant.local > /etc/nodename
sed -e 's|tribblix.local|tribblix.pet-power-plant.local|g' \
  < /etc/inet/hosts > /etc/inet/hosts.tmp \
  && mv /etc/inet/hosts.tmp /etc/inet/hosts
echo "10.0.2.2:/Users/schmonz/trees	- /export/home/schmonz/trees	nfs	-	yes	bg" >> /etc/vfstab
passwd schmonz
login schmonz
mkdir trees
su
reboot -p
```
