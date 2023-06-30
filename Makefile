.PHONY: install-bin install-etc
pkgbuild: install-bin install-etc

install-bin:
	mkdir -p $${HOME}/bin
	ln -sf `pwd`/bin/pkgbuild-* $${HOME}/bin
	pkgbuild-isvm 2>/dev/null || ln -sf `pwd`/bin/qemu-* `pwd`/bin/pkgvm $${HOME}/bin
	ln -sf $${HOME}/bin/pkgbuild-make $${HOME}/bin/make
	ln -sf /opt/pkg/bin/cvs-for-gits $${HOME}/bin/cvs

install-etc:
	pkgbuild-isvm 2>/dev/null || ln -sf `pwd`/etc/pkgbuild-vm-hostnames $${HOME}/.ssh
