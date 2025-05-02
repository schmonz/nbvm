.PHONY: install-bin

install-bin:
	mkdir -p $${HOME}/bin
	ln -sf `pwd`/bin/nbvm $${HOME}/bin
	nbvm isvm 2>/dev/null || ln -sf `pwd`/bin/qemu-* `pwd`/bin/nb $${HOME}/bin
