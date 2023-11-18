.PHONY: install-bin
pkgbuild: install-bin

install-bin:
	mkdir -p $${HOME}/bin
	ln -sf `pwd`/bin/pkgbuild $${HOME}/bin
	pkgbuild isvm 2>/dev/null || ln -sf `pwd`/bin/qemu-* `pwd`/bin/pkgvm $${HOME}/bin
	( echo '#!/bin/sh' && echo 'exec pkgbuild make "$$@"' ) > $${HOME}/bin/make
	chmod +x $${HOME}/bin/make
	ln -sf /opt/pkg/bin/cvs-for-gits $${HOME}/bin/cvs
