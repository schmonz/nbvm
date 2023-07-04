#/usr/bin/env bash

_pkgbuild_completions() {
	COMPREPLY=$(compgen -W "$(pkgbuild 2>&1 | sed -e 's|^pkgbuild ||' -e 's/|/ /g')")
}

complete -F _pkgbuild_completions pkgbuild
