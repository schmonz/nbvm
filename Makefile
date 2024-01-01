.PHONY: install-bin

install-bin:
	mkdir -p $${HOME}/bin
	ln -sf `pwd`/bin/nbvm $${HOME}/bin
	nbvm isvm 2>/dev/null || ln -sf `pwd`/bin/qemu-* `pwd`/bin/nb $${HOME}/bin
	ln -sf `pwd`/bin/nbpkg $${HOME}/bin
	( echo '#!/bin/sh' && echo 'exec nbpkg make "$$@"' ) > $${HOME}/bin/make
	chmod +x $${HOME}/bin/make
	ln -sf /opt/pkg/bin/cvs-for-gits $${HOME}/bin/cvs
