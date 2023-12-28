# package-builders

## What's here

For increasingly arbitrary combinations of...

- Unixy host/guest OSes
- hardware architectures
- emulation and virtualization tools

...we have a consistent shell UI...

- for **host** to control headless guest VMs: `pkgvm`
- for **guest** to perform various in-system actions: `pkgbuild`

(There are also a few miscellaneous supporting scripts waiting to be properly integrated into one or the other.)

These tools (and this repo) need better names.
So what if _I_ happen to be using them, at present, to provide a variety of platforms on which to build packages?
They're useful to anyone managing a heterogeneous VM farm.
Please suggest names that convey this more accurately and/or are easier to type. :-)

## Why (generally)

In principle, when I'm responsible for outcomes, I want to encounter problems myself as early as possible, so as to:

1. Narrow them down with minimal time and brain, and
2. Consider mitigation options with maximal time and brain.

## Why (this repo specifically)

In practice, this repo helps me:

- As a pkgsrc developer, to make sure all my packages work on a wide variety of platforms.
- As a server administrator, to update every week to a fresh-built set of the latest packages I rely on (not only mine).

## Possible alternatives

I should probably evaluate the following to see if they can run my free choice of guest OS/architecture (for instance, NetBSD/mac68k) on my free choice of host OS/architecture (for instance, macOS/arm64).

- [quickemu](https://github.com/quickemu-project/quickemu)
- [vagrant](https://developer.hashicorp.com/vagrant/docs/cli)
- [virsh](https://www.libvirt.org/manpages/virsh.html)

## Goals

### Short-term

- Automate more manual steps
- Add non-`qemu` guests
  (such as [NetBSD/vax](https://www.netbsd.org/ports/vax/emulator-howto.html))
- Pick a console server to catch `pkgvm start` output

### Medium-term

- Connect two hosts (such as `aarch64` and `x86_64`) in tandem:
  for any guest, run where virtualized, else run where emulation
  is probably "faster"
- Learn how to do a (limited) bulk build and publish (for myself) the results
- Iterate over all guests

### Long-term

- Have these tools adopted as official pkgsrc build infrastructure
- Allow pkgsrc developers to submit proposed changes _before_ committing, to see how they build across a wide variety of platforms
