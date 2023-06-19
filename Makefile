pkgbuild:
	mkdir -p $${HOME}/bin
	ln -sf `pwd`/bin/pkgbuild-* `pwd`/bin/qemu-* `pwd`/bin/pkgvm-* $${HOME}/bin
	ln -sf $${HOME}/bin/pkgbuild-make $${HOME}/bin/make
	ln -sf /opt/pkg/bin/cvs-for-gits $${HOME}/bin/cvs
