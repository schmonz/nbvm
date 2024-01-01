#/usr/bin/env bash

_nbpkg_completions() {
	COMPREPLY=$(compgen -W "$(nbpkg 2>&1 | sed -e 's|^nbpkg ||' -e 's/|/ /g')")
}

complete -F _nbpkg_completions nbpkg
